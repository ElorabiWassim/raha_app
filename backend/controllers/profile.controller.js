const supabase = require('../config/supabase');

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

      // Update Auth User Metadata if full_name changed
      if (userUpdates.full_name) {
        await supabase.auth.updateUser({
          data: { full_name: userUpdates.full_name },
        });
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

    const { error } = await supabase.auth.updateUser({
      password: newPassword,
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

    // Delete Auth user (will cascade to other tables if foreign keys are set up properly)
    const { error } = await supabase.auth.admin.deleteUser(userId);

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
  deleteAccount,
};
