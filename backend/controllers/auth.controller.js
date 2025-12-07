const supabase = require('../config/supabase');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');

console.log('✅ Auth Controller Loaded - Custom Node.js Auth with Bcrypt + JWT');

// Helper to generate JWTs
const generateTokens = (user) => {
  const payload = {
    user_id: user.user_id,
    role: user.role,
    email: user.email // optional
  };

  const accessToken = jwt.sign(payload, process.env.JWT_SECRET || 'your-secret-key', { expiresIn: '1d' });
  const refreshToken = jwt.sign(payload, process.env.JWT_REFRESH_SECRET || 'your-refresh-secret-key', { expiresIn: '7d' });

  return { accessToken, refreshToken };
};

const signupHomeowner = async (req, res) => {
  console.log('=== Signup Homeowner Request ===');
  console.log('Body:', req.body);
  try {
    const { email, password, fullName, phoneNumber, homeAddress, dateOfBirth } = req.body;

    // 1. Check if user exists
    const { data: existingUser } = await supabase
      .from('users')
      .select('user_id')
      .eq('email', email)
      .single();

    if (existingUser) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    // 2. Hash Password
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    // 3. Generate UUID for user
    const userId = crypto.randomUUID();

    // 4. Insert into users table
    const { data: user, error: userError } = await supabase
      .from('users')
      .insert([
        {
          user_id: userId,
          email,
          password: passwordHash, // Using 'password' column to store hash
          full_name: fullName,
          phone_number: phoneNumber,
          role: 'homeowner',
          status: 'active',
        },
      ])
      .select()
      .single();

    if (userError) {
      console.error('User DB Insert Error:', userError);
      return res.status(500).json({ error: 'Failed to create user account' });
    }

    // 4. Insert into homeowners table
    const { error: hoError } = await supabase
      .from('homeowners')
      .insert([
        {
          homeowner_id: user.user_id,
          home_address: homeAddress,
          date_of_birth: dateOfBirth,
        },
      ]);

    if (hoError) {
       // Rollback user
       await supabase.from('users').delete().eq('user_id', user.user_id);
       console.error('Homeowner DB Insert Error:', hoError);
       return res.status(500).json({ error: 'Failed to create homeowner profile' });
    }

    // 5. Generate Tokens
    const { accessToken, refreshToken } = generateTokens(user);

    res.status(201).json({
      message: 'Homeowner registered successfully',
      user: { ...user, id: user.user_id }, // Map user_id to id for frontend consistency
      session: {
        access_token: accessToken,
        refresh_token: refreshToken,
      }
    });
  } catch (error) {
    console.error('Signup Exception:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const signupProvider = async (req, res) => {
  try {
    const { email, password, fullName, phoneNumber, workingAddress, dateOfBirth, serviceType, experienceYears, description } = req.body;

    // 1. Check if user exists
    const { data: existingUser } = await supabase
      .from('users')
      .select('user_id')
      .eq('email', email)
      .single();

    if (existingUser) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    // 2. Hash Password
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    // 3. Generate UUID for user
    const userId = crypto.randomUUID();

    // 4. Insert into users table
    const { data: user, error: userError } = await supabase
      .from('users')
      .insert([
        {
          user_id: userId,
          email,
          password: passwordHash,
          full_name: fullName,
          phone_number: phoneNumber,
          role: 'service_provider',
          status: 'active',
        },
      ])
      .select()
      .single();

    if (userError) {
      console.error('User DB Insert Error:', userError);
      return res.status(500).json({ error: 'Failed to create user account' });
    }

    // 4. Insert into service_providers table
    const spData = {
      sp_id: user.user_id,
      working_address: workingAddress,
      date_of_birth: dateOfBirth,
      experience_years: experienceYears || 0,
      description: description || '',
      verification_status: 'pending',
      jobs_done: 0,
      rating_avg: 0,
    };
    
    if (serviceType) {
        spData.service_type = serviceType;
    }

    const { error: spError } = await supabase
      .from('service_providers')
      .insert([spData]);

    if (spError) {
      await supabase.from('users').delete().eq('user_id', user.user_id);
      console.error('SP DB Insert Error:', spError);
      return res.status(500).json({ error: 'Failed to create service provider profile' });
    }

    // 5. Generate Tokens
    const { accessToken, refreshToken } = generateTokens(user);

    res.status(201).json({
      message: 'Service Provider registered successfully',
      user: { ...user, id: user.user_id },
      session: {
        access_token: accessToken,
        refresh_token: refreshToken,
      }
    });
  } catch (error) {
    console.error('Signup Exception:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // 1. Fetch user
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('email', email)
      .single();

    if (error || !user) {
        return res.status(401).json({ error: 'Invalid email or password' });
    }

    // 2. Check Password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        return res.status(401).json({ error: 'Invalid email or password' });
    }

    // 3. Check Status
    if (user.status === 'banned' || user.status === 'disabled') {
        return res.status(403).json({ 
            error: `Account is ${user.status}. Please contact support.` 
        });
    }

    // 4. Generate Tokens
    const { accessToken, refreshToken } = generateTokens(user);

    res.json({
      message: 'Login successful',
      user: { ...user, id: user.user_id },
      session: {
        access_token: accessToken,
        refresh_token: refreshToken, // Frontend handles storage
      },
      // Note: We are technically strictly "access_token" focused in headers, 
      // but returning refresh_token allows the client to implement rotation later.
    });
  } catch (error) {
    console.error('Login Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const logout = async (req, res) => {
  // Stateless logout (client clears token)
  res.json({ message: 'Logged out successfully' });
};

const refreshToken = async (req, res) => {
  try {
    const { refresh_token } = req.body;
    if (!refresh_token) return res.status(400).json({ error: 'Refresh token required' });

    // Verify token
    try {
        const decoded = jwt.verify(refresh_token, process.env.JWT_REFRESH_SECRET || 'your-refresh-secret-key');
        
        // Fetch fresh user data
        const { data: user, error } = await supabase
            .from('users')
            .select('*')
            .eq('user_id', decoded.user_id)
            .single();

        if (error || !user) return res.status(401).json({ error: 'User not found' });

        // Issue new tokens
        const tokens = generateTokens(user);
        
        res.json({
            session: {
                access_token: tokens.accessToken,
                refresh_token: tokens.refreshToken
            },
            user: { ...user, id: user.user_id }
        });

    } catch (err) {
        return res.status(401).json({ error: 'Invalid refresh token' });
    }
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
