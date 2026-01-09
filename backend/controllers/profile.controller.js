const supabase = require('../config/supabase');
const bcrypt = require('bcryptjs');

const getProfile = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const role = req.user.role;

    let profileData = { ...req.user };

    if (role === 'homeowner') {
      const { data: homeownerData, error } = await supabase
        .from('homeowners')
        .select('*')
        .eq('homeowner_id', userId)
        .single();

      if (error && error.code !== 'PGRST116') {
        console.error('Error fetching homeowner profile:', error);
      }

      if (homeownerData) {
        profileData = { ...profileData, ...homeownerData };
      }
    } else if (role === 'service_provider') {
      const { data: spData, error } = await supabase
        .from('service_providers')
        .select('*')
        .eq('sp_id', userId)
        .single();

      if (error && error.code !== 'PGRST116') {
        console.error('Error fetching SP profile:', error);
      }

      if (spData) {
        profileData = { ...profileData, ...spData };
      }
    }

    res.json({ profile: profileData });
  } catch (error) {
    console.error('Get Profile Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
async function getServiceProviderProfile(req, res) {
  try {
    const { sp_id } = req.query; 

    if (!sp_id) return res.status(400).json({ error: "sp_id is required" });

    // 1. Get Provider Info
    const { data: spData, error: spError } = await supabase
      .from('service_providers')
      .select(`
        sp_id,
        description,
        working_address,
        experience_years,
        jobs_done,
        profile_picture_url,
        users:users!service_providers_sp_id_fkey ( full_name )
      `)
      .eq('sp_id', sp_id)
      .maybeSingle();

    if (spError || !spData) return res.status(404).json({ error: "Provider not found" });

    // 2. Get Reviews
    const { data: reviewsData, error: reviewError } = await supabase
      .from('reviews')
      .select('rating')
      .eq('sp_id', sp_id);

    let avgReview = 0;
    let totalReviews = 0;

    if (!reviewError && reviewsData && reviewsData.length > 0) {
      totalReviews = reviewsData.length;
      const sumRatings = reviewsData.reduce((sum, r) => sum + r.rating, 0);
      avgReview = sumRatings / totalReviews;
    }

    const profile = {
      sp_id: spData.sp_id,
      name: spData.users?.full_name || null,
      description: spData.description,
      average_review: avgReview,     // Dynamic Rating
      total_reviews: totalReviews,   // Dynamic Count
      location: spData.working_address,
      jobs_done: spData.jobs_done,
      experience: spData.experience_years,
      profile_picture_url : spData.profile_picture_url
    };

    return res.status(200).json(profile);

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}

module.exports = { getServiceProviderProfile };
const updateProfile = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const role = req.user.role;
    const updates = req.body;

    // Define which fields belong to which table
    const userFields = ['full_name', 'phone_number'];
    const homeownerFields = ['home_address', 'date_of_birth'];
    const spFields = [
      'working_address',
      'date_of_birth',
      'service_type',
      'experience_years',
      'description',
    ];

    const userUpdates = {};
    const roleUpdates = {};

    // Separate updates by table
    Object.keys(updates).forEach((key) => {
      if (userFields.includes(key)) {
        userUpdates[key] = updates[key];
      }

      if (role === 'homeowner' && homeownerFields.includes(key)) {
        roleUpdates[key] = updates[key];
      } else if (role === 'service_provider' && spFields.includes(key)) {
        roleUpdates[key] = updates[key];
      }
    });

    // Update users table
    if (Object.keys(userUpdates).length > 0) {
      const { error } = await supabase
        .from('users')
        .update(userUpdates)
        .eq('user_id', userId);

      if (error) {
        console.error('User update error:', error);
        return res.status(400).json({ error: error.message });
      }

    }

    // Update role-specific table
    if (Object.keys(roleUpdates).length > 0) {
      const tableName = role === 'homeowner' ? 'homeowners' : 'service_providers';
      const idField = role === 'homeowner' ? 'homeowner_id' : 'sp_id';

      const { error } = await supabase
        .from(tableName)
        .update(roleUpdates)
        .eq(idField, userId);

      if (error) {
        console.error(`${tableName} update error:`, error);
        return res.status(400).json({ error: error.message });
      }
    }

    res.json({ message: 'Profile updated successfully' });
  } catch (error) {
    console.error('Update Profile Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const changePassword = async (req, res) => {
  try {
    const { newPassword } = req.body;
    if (!newPassword) return res.status(400).json({ error: 'New password required' });

    const userId = req.user.user_id;
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    const { error } = await supabase
      .from('users')
      .update({ password: hashedPassword, updated_at: new Date().toISOString() })
      .eq('user_id', userId);

    if (error) return res.status(400).json({ error: error.message });

    res.json({ message: 'Password updated successfully' });
  } catch (error) {
    console.error('Change Password Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const deleteAccount = async (req, res) => {
  try {
    const userId = req.user.user_id;

    // Best-effort cleanup. If you have FK cascades, these deletes are safe.
    await supabase.from('provider_applications').delete().eq('user_id', userId);
    await supabase.from('homeowners').delete().eq('homeowner_id', userId);
    await supabase.from('service_providers').delete().eq('sp_id', userId);

    const { error } = await supabase.from('users').delete().eq('user_id', userId);

    if (error) {
      console.error('Delete user error:', error);
      return res.status(400).json({ error: error.message });
    }

    res.json({ message: 'Account deleted successfully' });
  } catch (error) {
    console.error('Delete Account Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  getProfile,
  updateProfile,
  changePassword,
  deleteAccount,getServiceProviderProfile
};
