const supabase = require('../config/supabase');

const signupHomeowner = async (req, res) => {
  try {
    const { email, password, fullName, phone } = req.body;

    // 1. Create Auth User
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName,
          role: 'homeowner',
        },
      },
    });

    if (authError) return res.status(400).json({ error: authError.message });

    // 2. Insert into users table
    const { error: dbError } = await supabase
      .from('users')
      .insert([
        {
          user_id: authData.user.id,
          email,
          full_name: fullName,
          phone,
          role: 'homeowner',
        },
      ]);

    if (dbError) {
      // Cleanup auth user if DB insert fails (optional but good practice)
      // await supabase.auth.admin.deleteUser(authData.user.id);
      return res.status(400).json({ error: dbError.message });
    }

    res.status(201).json({
      message: 'Homeowner registered successfully',
      user: authData.user,
      session: authData.session,
    });
  } catch (error) {
    console.error('Signup Homeowner Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const signupProvider = async (req, res) => {
  try {
    const { email, password, fullName, phone, businessName, category, description, location } = req.body;

    // 1. Create Auth User
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName,
          role: 'service_provider',
        },
      },
    });

    if (authError) return res.status(400).json({ error: authError.message });

    // 2. Insert into users table
    const { error: userError } = await supabase
      .from('users')
      .insert([
        {
          user_id: authData.user.id,
          email,
          full_name: fullName,
          phone,
          role: 'service_provider',
        },
      ]);

    if (userError) return res.status(400).json({ error: userError.message });

    // 3. Insert into service_providers table
    const { error: spError } = await supabase
      .from('service_providers')
      .insert([
        {
          sp_id: authData.user.id,
          business_name: businessName,
          category,
          description,
          location,
          verification_status: 'pending', // Mark as pending
          // Store other application data if needed
        },
      ]);

    if (spError) return res.status(400).json({ error: spError.message });

    res.status(201).json({
      message: 'Service Provider registered successfully. Account is pending verification.',
      user: authData.user,
      session: authData.session,
    });
  } catch (error) {
    console.error('Signup Provider Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) return res.status(401).json({ error: error.message });

    // Fetch user role from DB to include in response
    const { data: userData, error: userError } = await supabase
        .from('users')
        .select('role')
        .eq('user_id', data.user.id)
        .single();
    
    if (userError) {
        // Fallback if user not in DB but in Auth (shouldn't happen ideally)
        console.warn("User logged in but not found in 'users' table");
    }

    res.json({
      message: 'Login successful',
      user: { ...data.user, role: userData?.role },
      session: data.session,
    });
  } catch (error) {
    console.error('Login Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const logout = async (req, res) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');
    if (!token) return res.status(400).json({ error: 'Token required' });

    const { error } = await supabase.auth.signOut(token);

    if (error) return res.status(400).json({ error: error.message });

    res.json({ message: 'Logged out successfully' });
  } catch (error) {
    console.error('Logout Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const refreshToken = async (req, res) => {
    try {
        const { refresh_token } = req.body;
        if (!refresh_token) return res.status(400).json({ error: 'Refresh token required' });

        const { data, error } = await supabase.auth.refreshSession({ refresh_token });

        if (error) return res.status(401).json({ error: error.message });

        res.json({
            session: data.session,
            user: data.user
        });

    } catch (error) {
        console.error('Refresh Token Error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

module.exports = {
  signupHomeowner,
  signupProvider,
  login,
  logout,
  refreshToken
};
