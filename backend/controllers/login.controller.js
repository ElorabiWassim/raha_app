const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const supabase = require('../config/supabase');

const register = async (req, res) => {
  try {
    const { full_name, email, phone_number, password, role, home_address } = req.body;

    // Validate role
    if (role !== 'service_provider' && role !== 'homeowner') {
      return res.status(400).json({
        error: 'Invalid role. Only "service_provider" or "homeowner" are allowed.'
      });
    }

    // Check if email already exists
    const { data: existingUser, error: emailError } = await supabase
      .from('users')
      .select('email')
      .eq('email', email);

    if (emailError) {
      console.error('Database error:', emailError);
      return res.status(500).json({ error: 'Error checking email' });
    }

    if (existingUser && existingUser.length > 0) {
      return res.status(400).json({ error: 'Email already in use' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert new user
    const { data: newUser, error: insertError } = await supabase
      .from('users')
      .insert({
        full_name,
        email,
        phone_number,
        password: hashedPassword,
        role,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (insertError) {
      console.error('Insert error:', insertError);
      throw insertError;
    }

    // Create role-specific profile
    if (role === 'service_provider') {
      const { error: spError } = await supabase
        .from('service_providers')
        .insert({
          sp_id: newUser.user_id,
          created_at: new Date().toISOString(),

        });

      if (spError) {
        console.error('Service provider profile creation error:', spError);
        // Rollback: delete the user if service provider profile creation fails
        await supabase.from('users').delete().eq('user_id', newUser.user_id);
        return res.status(500).json({ error: 'Failed to create service provider profile' });
      }
    } else if (role === 'homeowner') {
      const { error: hoError } = await supabase
        .from('homeowners')
        .insert({
          homeowner_id: newUser.user_id,
          home_address: home_address || null,


        });

      if (hoError) {
        console.error('Homeowner profile creation error:', hoError);
        // Rollback: delete the user if homeowner profile creation fails
        await supabase.from('users').delete().eq('user_id', newUser.user_id);
        return res.status(500).json({ error: 'Failed to create homeowner profile' });
      }
    } else if (role === 'admin') {

    }

    // Generate JWT token
    const token = jwt.sign(
      { user_id: newUser.user_id, role: newUser.role, email: newUser.email },
      process.env.JWT_SECRET,
      { expiresIn: '24h' } // Increased to 24 hours
    );

    res.status(201).json({
      message: 'User registered successfully',
      user: {
        id: newUser.user_id,
        user_id: newUser.user_id,
        full_name: newUser.full_name,
        email: newUser.email,
        role: newUser.role,
      },
      session: {
        access_token: token,
        refresh_token: token,
        expires_in: 86400,
        token_type: 'bearer'
      }
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ error: 'Failed to register user' });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Hardcoded admin bypass
    if (email === 'admin@gmail.com' && password === '123456') {
      console.log('Admin hardcoded login successful');

      // Generate a proper JWT token for admin
      const adminToken = jwt.sign(
        {
          user_id: '3fe68579-15f3-4460-a9a9-1ec6aea97c5d',
          role: 'admin',
          email: 'admin@gmail.com'
        },
        process.env.JWT_SECRET,
        { expiresIn: '24h' }
      );

      return res.json({
        message: 'Admin login successful',
        user: {
          id: '3fe68579-15f3-4460-a9a9-1ec6aea97c5d',
          user_id: '3fe68579-15f3-4460-a9a9-1ec6aea97c5d',
          email: 'admin@gmail.com',
          role: 'admin',
          full_name: 'Admin'
        },
        session: {
          access_token: adminToken,
          refresh_token: adminToken,
          expires_in: 86400
        }
      });
    }

    // Fetch user by email
    const { data: users, error: fetchError } = await supabase
      .from('users')
      .select('*')
      .eq('email', email);

    if (fetchError) {
      console.error('Database error:', fetchError);
      return res.status(500).json({ error: 'Database error' });
    }

    // Check if user exists
    if (!users || users.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = users[0];

    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Invalid password' });
    }

    // Check if role-specific profile exists, create if missing
    if (user.role === 'service_provider') {
      const { data: spProfile, error: spError } = await supabase
        .from('service_providers')
        .select('sp_id')
        .eq('sp_id', user.user_id)
        .single();

      // If profile doesn't exist, create it
      if (spError || !spProfile) {
        console.log('Creating service provider profile for user:', user.user_id);
        const { error: createSpError } = await supabase
          .from('service_providers')
          .insert({
            sp_id: user.user_id,
            verification_status: 'pending',
            created_at: new Date().toISOString(),
          });

        if (createSpError) {
          console.error('Failed to create service provider profile:', createSpError);
        } else {
          console.log('Service provider profile created successfully');
        }
      }
    } else if (user.role === 'homeowner') {
      const { data: hoProfile, error: hoError } = await supabase
        .from('homeowners')
        .select('homeowner_id')
        .eq('homeowner_id', user.user_id)
        .single();

      // If profile doesn't exist, create it
      if (hoError || !hoProfile) {
        console.log('Creating homeowner profile for user:', user.user_id);
        const { error: createHoError } = await supabase
          .from('homeowners')
          .insert({
            homeowner_id: user.user_id,
            created_at: new Date().toISOString(),
          });

        if (createHoError) {
          console.error('Failed to create homeowner profile:', createHoError);
        } else {
          console.log('Homeowner profile created successfully');
        }
      }
    }

    // Generate JWT token
    const token = jwt.sign(
      { user_id: user.user_id, role: user.role, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({
      message: 'Login successful',
      user: {
        id: user.user_id,
        user_id: user.user_id,
        full_name: user.full_name,
        email: user.email,
        role: user.role,
      },
      session: {
        access_token: token,
        refresh_token: token,
        expires_in: 86400,
        token_type: 'bearer'
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Failed to login user' });
  }
};

module.exports = { register, login };