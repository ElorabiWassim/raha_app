const supabase = require('../config/supabase');

const getProfile = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const role = req.user.role;

    let profileData = req.user;

    if (role === 'service_provider') {
      const { data: spData, error } = await supabase
        .from('service_providers')
        .select('*')
        .eq('sp_id', userId)
        .single();
      
      if (error && error.code !== 'PGRST116') { // Ignore not found if just created
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

const updateProfile = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const role = req.user.role;
    const updates = req.body;

    // Separate user table updates from SP table updates
    const userUpdates = {};
    const spUpdates = {};

    const userFields = ['full_name', 'phone', 'avatar_url']; // Add other user fields
    const spFields = ['business_name', 'category', 'description', 'location', 'years_experience', 'hourly_rate']; // Add other SP fields

    Object.keys(updates).forEach(key => {
        if (userFields.includes(key)) userUpdates[key] = updates[key];
        if (role === 'service_provider' && spFields.includes(key)) spUpdates[key] = updates[key];
    });

    // Update users table
    if (Object.keys(userUpdates).length > 0) {
        const { error } = await supabase
            .from('users')
            .update(userUpdates)
            .eq('user_id', userId);
        
        if (error) return res.status(400).json({ error: error.message });
    }

    // Update service_providers table
    if (role === 'service_provider' && Object.keys(spUpdates).length > 0) {
        const { error } = await supabase
            .from('service_providers')
            .update(spUpdates)
            .eq('sp_id', userId);

        if (error) return res.status(400).json({ error: error.message });
    }

    // Update Auth User Metadata if needed (e.g. full_name)
    if (userUpdates.full_name) {
        await supabase.auth.updateUser({
            data: { full_name: userUpdates.full_name }
        });
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

    const { error } = await supabase.auth.updateUser({
      password: newPassword
    });

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

    // Delete from DB first (cascade should handle it usually, but let's be safe or rely on Supabase Auth deletion hook if configured)
    // Here we assume we just delete the Auth user and let Supabase cascade or handle the rest.
    // However, the admin API is needed to delete a user by ID usually, OR the user can delete themselves.
    // supabase.auth.admin.deleteUser requires service_role key.
    // Standard user deletion might not be directly exposed via client lib without admin rights unless configured.
    // BUT, we are on the backend, so we can use the service key if we initialized supabase with it?
    // The config/supabase.js uses process.env.SUPABASE_SERVICE_KEY, so we have admin rights!
    
    const { error } = await supabase.auth.admin.deleteUser(userId);

    if (error) return res.status(400).json({ error: error.message });

    // Optionally manually delete from tables if cascade not set up
    // await supabase.from('users').delete().eq('user_id', userId);

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
  deleteAccount
};
