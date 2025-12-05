const supabase = require('../config/supabase');

const signupHomeowner = async (req, res) => {
  try {
    const { email, password, fullName, phoneNumber, homeAddress, dateOfBirth } = req.body;

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

    const userId = authData.user.id;

    // 2. Insert into users table
    const { error: userError } = await supabase
      .from('users')
      .insert([
        {
          user_id: userId,
          email,
          full_name: fullName,
          phone_number: phoneNumber,
          role: 'homeowner',
          status: 'active',
        },
      ]);

    if (userError) {
      console.error('User insert error:', userError);
      return res.status(400).json({ error: userError.message });
    }

    // 3. Insert into homeowners table
    const { error: homeownerError } = await supabase
      .from('homeowners')
      .insert([
        {
          homeowner_id: userId,
          home_address: homeAddress,
          date_of_birth: dateOfBirth,
        },
      ]);

    if (homeownerError) {
      console.error('Homeowner insert error:', homeownerError);
      return res.status(400).json({ error: homeownerError.message });
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
    const { 
      email, 
      password, 
      fullName, 
      phoneNumber, 
      workingAddress, 
      dateOfBirth, 
      serviceType, 
      experienceYears, 
      description,
      documentsUrls 
    } = req.body;

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

    const userId = authData.user.id;

    // 2. Insert into users table
    const { error: userError } = await supabase
      .from('users')
      .insert([
        {
          user_id: userId,
          email,
          full_name: fullName,
          phone_number: phoneNumber,
          role: 'service_provider',
          status: 'active',
        },
      ]);

    if (userError) {
      console.error('User insert error:', userError);
      return res.status(400).json({ error: userError.message });
    }

    // 3. Insert into service_providers table
    const { error: spError } = await supabase
      .from('service_providers')
      .insert([
        {
          sp_id: userId,
          working_address: workingAddress,
          date_of_birth: dateOfBirth,
          service_type: serviceType,
          experience_years: experienceYears,
          description,
          verification_status: 'pending',
          jobs_done: 0,
          rating_avg: 0,
        },
      ]);

    if (spError) {
      console.error('Service provider insert error:', spError);
      return res.status(400).json({ error: spError.message });
    }

    // 4. Insert into provider_application table
    const { error: appError } = await supabase
      .from('provider_application')
      .insert([
        {
          user_id: userId,
          documents_urls: documentsUrls || {},
          status: 'pending',
        },
      ]);

    if (appError) {
      console.error('Provider application insert error:', appError);
      return res.status(400).json({ error: appError.message });
    }

    res.status(201).json({
      message: 'Service Provider registered successfully. Account created, application pending admin review.',
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

    // Fetch user data from DB
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('role, status, full_name')
      .eq('user_id', data.user.id)
      .single();

    if (userError) {
      console.warn("User logged in but not found in 'users' table");
      return res.status(404).json({ error: 'User profile not found' });
    }

    // Check if user is banned or disabled
    if (userData.status === 'banned' || userData.status === 'disabled') {
      return res.status(403).json({ 
        error: `Account is ${userData.status}. Please contact support.` 
      });
    }

    res.json({
      message: 'Login successful',
      user: { 
        ...data.user, 
        role: userData.role, 
        status: userData.status,
        full_name: userData.full_name
      },
      session: data.session,
    });
  } catch (error) {
    console.error('Login Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const logout = async (req, res) => {
  try {
    const { error } = await supabase.auth.signOut();

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
      user: data.user,
    });
  } catch (error) {
    console.error('Refresh Token Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  signupHomeowner,
  signupProvider,
  login,
  logout,
  refreshToken,
};
