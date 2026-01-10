const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const supabase = require('../config/supabase');
const { OAuth2Client } = require('google-auth-library');
const { sendPasswordResetEmail, isEmailConfigured } = require('../services/mailer');

const PROVIDER_APPLICATIONS_TABLE = 'provider_applications';
const PASSWORD_RESET_EXPIRES_MINUTES = Number(process.env.PASSWORD_RESET_EXPIRES_MINUTES || 15);

const sha256 = (value) => crypto.createHash('sha256').update(value).digest('hex');
const getResetJwtSecret = () => process.env.PASSWORD_RESET_JWT_SECRET || process.env.JWT_SECRET;

const getGoogleClient = () => {
  const googleClientId = process.env.GOOGLE_CLIENT_ID;
  if (!googleClientId) {
    return { error: 'Missing GOOGLE_CLIENT_ID in backend environment' };
  }
  return { client: new OAuth2Client(googleClientId) };
};

const ensureVerifiedServiceProvider = async (userId) => {
  const { data: spData, error } = await supabase
    .from('service_providers')
    .select('verification_status')
    .eq('sp_id', userId)
    .maybeSingle();

  if (error || !spData) {
    return { verified: false, status: null };
  }

  return {
    verified: spData.verification_status === 'verified',
    status: spData.verification_status,
  };
};

const getGoogleUserFromAccessToken = async (accessToken) => {
  const response = await fetch('https://openidconnect.googleapis.com/v1/userinfo', {
    method: 'GET',
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });

  const text = await response.text();
  let json;
  try {
    json = text ? JSON.parse(text) : {};
  } catch {
    json = { raw: text };
  }

  if (!response.ok) {
    const err = new Error('Failed to fetch Google user info');
    err.details = json;
    err.status = response.status;
    throw err;
  }

  if (!json || !json.email) {
    const err = new Error('Invalid Google token (missing email)');
    err.details = json;
    err.status = 401;
    throw err;
  }

  return {
    email: json.email,
    name:
      json.name ||
      [json.given_name, json.family_name].filter(Boolean).join(' ') ||
      json.given_name ||
      'Google User',
    picture: json.picture,
    email_verified: json.email_verified,
  };
};

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
          verification_status: 'pending',
          created_at: new Date().toISOString(),

        });

      if (spError) {
        console.error('Service provider profile creation error:', spError);
        // Rollback: delete the user if service provider profile creation fails
        await supabase.from('users').delete().eq('user_id', newUser.user_id);
        return res.status(500).json({ error: 'Failed to create service provider profile' });
      }

      const { error: appError } = await supabase
        .from(PROVIDER_APPLICATIONS_TABLE)
        .insert({
          user_id: newUser.user_id,
          documents_urls: {},
          status: 'pending',
        });

      if (appError) {
        console.error('Provider application creation error:', appError);
        await supabase.from('service_providers').delete().eq('sp_id', newUser.user_id);
        await supabase.from('users').delete().eq('user_id', newUser.user_id);
        return res.status(500).json({ error: 'Failed to create provider application' });
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

const signupHomeowner = async (req, res) => {
  try {
    const { email, password, fullName, phoneNumber, homeAddress, dateOfBirth } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'email and password are required' });
    }

    const { data: existingUser, error: existingError } = await supabase
      .from('users')
      .select('user_id')
      .eq('email', email)
      .maybeSingle();

    if (existingError) {
      console.error('Error checking existing user:', existingError);
      return res.status(500).json({ error: 'Database error' });
    }

    if (existingUser) {
      return res.status(409).json({ error: 'Email already in use' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const now = new Date().toISOString();

    const { data: newUser, error: insertError } = await supabase
      .from('users')
      .insert({
        full_name: fullName || null,
        email,
        phone_number: phoneNumber || null,
        password: hashedPassword,
        role: 'homeowner',
        created_at: now,
        updated_at: now,
      })
      .select()
      .single();

    if (insertError) {
      console.error('Insert error:', insertError);
      return res.status(500).json({ error: 'Failed to create user' });
    }

    const { error: hoError } = await supabase
      .from('homeowners')
      .insert({
        homeowner_id: newUser.user_id,
        home_address: homeAddress || null,
        date_of_birth: dateOfBirth || null,
      });

    if (hoError) {
      console.error('Homeowner profile creation error:', hoError);
      await supabase.from('users').delete().eq('user_id', newUser.user_id);
      return res.status(500).json({ error: 'Failed to create homeowner profile' });
    }

    return res.status(201).json({
      message: 'Homeowner registered successfully',
      user: {
        id: newUser.user_id,
        user_id: newUser.user_id,
        full_name: newUser.full_name,
        email: newUser.email,
        role: newUser.role,
      },
    });
  } catch (error) {
    console.error('Signup Homeowner Error:', error);
    return res.status(500).json({ error: 'Internal server error' });
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
      documentsUrls,
    } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'email and password are required' });
    }

    const { data: existingUser, error: existingError } = await supabase
      .from('users')
      .select('user_id')
      .eq('email', email)
      .maybeSingle();

    if (existingError) {
      console.error('Error checking existing user:', existingError);
      return res.status(500).json({ error: 'Database error' });
    }

    if (existingUser) {
      return res.status(409).json({ error: 'Email already in use' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const now = new Date().toISOString();

    const { data: newUser, error: insertError } = await supabase
      .from('users')
      .insert({
        full_name: fullName || null,
        email,
        phone_number: phoneNumber || null,
        password: hashedPassword,
        role: 'service_provider',
        created_at: now,
        updated_at: now,
      })
      .select()
      .single();

    if (insertError) {
      console.error('Insert error:', insertError);
      return res.status(500).json({ error: 'Failed to create user' });
    }

    const spData = {
      sp_id: newUser.user_id,
      working_address: workingAddress || null,
      date_of_birth: dateOfBirth || null,
      experience_years: experienceYears ?? 0,
      description: description ?? '',
      verification_status: 'pending',
      jobs_done: 0,
      rating_avg: 0,
    };
    if (serviceType) {
      spData.service_type = serviceType;
    }

    const { error: spError } = await supabase.from('service_providers').insert([spData]);

    if (spError) {
      console.error('Service provider profile creation error:', spError);
      await supabase.from('users').delete().eq('user_id', newUser.user_id);
      return res.status(500).json({ error: 'Failed to create service provider profile' });
    }

    const { error: appError } = await supabase
      .from(PROVIDER_APPLICATIONS_TABLE)
      .insert({
        user_id: newUser.user_id,
        documents_urls: documentsUrls || {},
        status: 'pending',
      });

    if (appError) {
      console.error('Provider application creation error:', appError);
      await supabase.from('service_providers').delete().eq('sp_id', newUser.user_id);
      await supabase.from('users').delete().eq('user_id', newUser.user_id);
      return res.status(500).json({ error: 'Failed to create provider application' });
    }

    return res.status(201).json({
      message: 'Service Provider registered successfully. Account created, application pending admin review.',
      user: {
        id: newUser.user_id,
        user_id: newUser.user_id,
        full_name: newUser.full_name,
        email: newUser.email,
        role: newUser.role,
      },
    });
  } catch (error) {
    console.error('Signup Provider Error:', error);
    return res.status(500).json({ error: 'Internal server error' });
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

    // Only allow verified service providers to log in.
    if (user.role === 'service_provider') {
      const { verified, status } = await ensureVerifiedServiceProvider(user.user_id);
      if (!verified) {
        return res.status(403).json({
          error: 'Service provider not verified',
          status,
        });
      }
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

const googleAuth = async (req, res) => {
  try {
    const { idToken, accessToken, role, phone_number, home_address, working_address } = req.body;

    if (!idToken && !accessToken) {
      return res.status(400).json({ error: 'idToken or accessToken is required' });
    }
    const hasRole = role !== undefined && role !== null && role !== '';
    if (hasRole && role !== 'service_provider' && role !== 'homeowner') {
      return res.status(400).json({
        error: 'Invalid role. Only "service_provider" or "homeowner" are allowed.'
      });
    }

    let email;
    let fullNameFromGoogle;
    let pictureUrlFromGoogle;

    if (idToken) {
      const { client, error: clientError } = getGoogleClient();
      if (clientError) {
        return res.status(500).json({ error: clientError });
      }

      const ticket = await client.verifyIdToken({
        idToken,
        audience: process.env.GOOGLE_CLIENT_ID,
      });

      const payload = ticket.getPayload();
      if (!payload || !payload.email) {
        return res.status(401).json({ error: 'Invalid Google token (missing email)' });
      }

      email = payload.email;
      fullNameFromGoogle =
        payload.name ||
        [payload.given_name, payload.family_name].filter(Boolean).join(' ') ||
        payload.given_name ||
        'Google User';
      pictureUrlFromGoogle = payload.picture;

      // Some Google flows omit `picture` (and occasionally `name`) from the ID token.
      // If we also have an access token, use the OIDC userinfo endpoint as a safe fallback.
      if (accessToken && (!pictureUrlFromGoogle || String(pictureUrlFromGoogle).trim().length === 0)) {
        try {
          const userInfo = await getGoogleUserFromAccessToken(accessToken);
          if (userInfo.email_verified === false) {
            return res.status(401).json({ error: 'Google email is not verified' });
          }
          pictureUrlFromGoogle = userInfo.picture || pictureUrlFromGoogle;
          if (!fullNameFromGoogle || String(fullNameFromGoogle).trim().length === 0) {
            fullNameFromGoogle = userInfo.name;
          }
        } catch (e) {
          // Non-fatal: proceed with idToken data.
        }
      }
    } else {
      const userInfo = await getGoogleUserFromAccessToken(accessToken);
      if (userInfo.email_verified === false) {
        return res.status(401).json({ error: 'Google email is not verified' });
      }
      email = userInfo.email;
      fullNameFromGoogle = userInfo.name;
      pictureUrlFromGoogle = userInfo.picture;
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

    let user = users && users.length > 0 ? users[0] : null;
    let created = false;

    // If no role passed (login flow), allow it only for existing accounts.
    if (!hasRole && !user) {
      return res.status(400).json({
        error: 'role is required for new accounts. Please sign up and choose homeowner or service_provider.'
      });
    }

    const effectiveRole = hasRole ? role : user.role;

    // If user exists but role differs, block to avoid cross-role collisions
    if (user && hasRole && user.role && user.role !== role) {
      return res.status(409).json({
        error: `Account already exists with role: ${user.role}`
      });
    }

    if (!user) {
      // Create new user
      const randomPassword = crypto.randomBytes(32).toString('hex');
      const hashedPassword = await bcrypt.hash(randomPassword, 10);

      const { data: newUser, error: insertError } = await supabase
        .from('users')
        .insert({
          full_name: fullNameFromGoogle,
          email,
          phone_number: phone_number || null,
          password: hashedPassword,
          role: effectiveRole,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        })
        .select()
        .single();

      if (insertError) {
        console.error('Insert error:', insertError);
        return res.status(500).json({ error: 'Failed to create user' });
      }

      user = newUser;
      created = true;

      // Create role-specific profile
      if (effectiveRole === 'service_provider') {
        const { error: spError } = await supabase
          .from('service_providers')
          .insert({
            sp_id: user.user_id,
            verification_status: 'pending',
            created_at: new Date().toISOString(),
          });

        if (spError) {
          console.error('Service provider profile creation error:', spError);
          await supabase.from('users').delete().eq('user_id', user.user_id);
          return res.status(500).json({ error: 'Failed to create service provider profile' });
        }
      }

      if (effectiveRole === 'homeowner') {
        const { error: hoError } = await supabase
          .from('homeowners')
          .insert({
            homeowner_id: user.user_id,
            home_address: home_address || working_address || null,
          });

        if (hoError) {
          console.error('Homeowner profile creation error:', hoError);
          await supabase.from('users').delete().eq('user_id', user.user_id);
          return res.status(500).json({ error: 'Failed to create homeowner profile' });
        }
      }
    }

    // Best-effort: persist Google name onto users table and picture onto role table.
    // This keeps homeowner/service provider avatars consistent without requiring People API.
    try {
      const safePicture =
        typeof pictureUrlFromGoogle === 'string' && pictureUrlFromGoogle.trim().length > 0
          ? pictureUrlFromGoogle.trim()
          : null;

      const normalizedGoogleName =
        typeof fullNameFromGoogle === 'string' ? fullNameFromGoogle.trim() : '';
      const normalizedCurrentName =
        typeof user.full_name === 'string'
          ? user.full_name.trim()
          : (user.full_name ?? '').toString().trim();
      const emailLocal = typeof email === 'string' ? email.split('@')[0].trim() : '';

      // Update name when it's missing or looks like a placeholder.
      const nameUpdateNeeded =
        normalizedGoogleName.length > 0 &&
        (normalizedCurrentName.length === 0 ||
          normalizedCurrentName.toLowerCase() === 'google user' ||
          normalizedCurrentName.toLowerCase() === String(email || '').toLowerCase() ||
          (emailLocal.length > 0 && normalizedCurrentName.toLowerCase() === emailLocal.toLowerCase()));

      // 1) Persist name (users.full_name)
      if (nameUpdateNeeded) {
        const { data: updatedUser, error: nameError } = await supabase
          .from('users')
          .update({ full_name: normalizedGoogleName, updated_at: new Date().toISOString() })
          .eq('user_id', user.user_id)
          .select()
          .single();

        if (!nameError && updatedUser) {
          user = updatedUser;
        }
      }

      // 2) Persist picture on role table (homeowners/service_providers.profile_picture_url)
      if (safePicture && (effectiveRole === 'homeowner' || effectiveRole === 'service_provider')) {
        const tableName = effectiveRole === 'homeowner' ? 'homeowners' : 'service_providers';
        const idField = effectiveRole === 'homeowner' ? 'homeowner_id' : 'sp_id';

        // Only set if currently null or empty, so we don't override user-chosen photo.
        await supabase
          .from(tableName)
          .update({ profile_picture_url: safePicture })
          .eq(idField, user.user_id)
          .or('profile_picture_url.is.null,profile_picture_url.eq.');
      }
    } catch (e) {
      // Ignore if column doesn't exist or update fails; login should still succeed.
      console.warn('Google profile persistence skipped:', e?.message || e);
    }

    // Only allow verified service providers to log in.
    if (user && effectiveRole === 'service_provider') {
      const { verified, status } = await ensureVerifiedServiceProvider(user.user_id);
      if (!verified) {
        return res.status(403).json({
          error: 'Service provider not verified',
          status,
          message: created
            ? 'Account created, pending admin verification. Please wait for approval.'
            : undefined,
        });
      }
    }

    // Ensure profile exists for existing user
    if (user && effectiveRole === 'service_provider') {
      const { data: spProfile, error: spError } = await supabase
        .from('service_providers')
        .select('sp_id')
        .eq('sp_id', user.user_id)
        .single();

      if (spError || !spProfile) {
        await supabase.from('service_providers').insert({
          sp_id: user.user_id,
          verification_status: 'pending',
          created_at: new Date().toISOString(),
        });
      }

      // Ensure provider application exists so admin can review
      const { data: existingApp, error: appFetchError } = await supabase
        .from(PROVIDER_APPLICATIONS_TABLE)
        .select('application_id')
        .eq('user_id', user.user_id)
        .maybeSingle();

      if (appFetchError) {
        console.error('Provider application lookup error:', appFetchError);
      } else if (!existingApp) {
        const { error: appCreateError } = await supabase
          .from(PROVIDER_APPLICATIONS_TABLE)
          .insert({
            user_id: user.user_id,
            documents_urls: {},
            status: 'pending',
          });

        if (appCreateError) {
          console.error('Provider application creation error:', appCreateError);
        }
      }
    }

    if (user && effectiveRole === 'homeowner') {
      const { data: hoProfile, error: hoError } = await supabase
        .from('homeowners')
        .select('homeowner_id')
        .eq('homeowner_id', user.user_id)
        .single();

      if (hoError || !hoProfile) {
        await supabase.from('homeowners').insert({
          homeowner_id: user.user_id,
          home_address: home_address || working_address || null,
        });
      }
    }

    const token = jwt.sign(
      { user_id: user.user_id, role: user.role, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    return res.status(created ? 201 : 200).json({
      message: created ? 'Google signup successful' : 'Google login successful',
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
    console.error('Google auth error:', error);
    return res.status(500).json({ error: 'Failed to authenticate with Google' });
  }
};

const requestPasswordReset = async (req, res) => {
  try {
    const { email } = req.body;
    const normalizedEmail = (email || '').trim();
    if (!normalizedEmail) {
      return res.status(400).json({ error: 'Email is required' });
    }

    if (!getResetJwtSecret()) {
      return res.status(500).json({
        error: 'Password reset is not configured on the backend yet',
        hint: 'Missing PASSWORD_RESET_JWT_SECRET or JWT_SECRET in backend environment',
      });
    }

    // Don't reveal whether the email exists.
    const genericResponse = {
      message: 'If an account exists for that email, a reset token has been sent.',
    };

    const { data: user, error: userError } = await supabase
      .from('users')
      .select('user_id,email,password,updated_at')
      .eq('email', normalizedEmail)
      .maybeSingle();

    if (userError) {
      console.error('Password reset lookup error:', userError);
      return res.status(500).json({ error: 'Database error' });
    }

    if (!user) {
      return res.status(200).json(genericResponse);
    }

    // Stateless reset token: once password changes, token becomes invalid because pwv changes.
    const pwVersion = sha256(String(user.password || user.updated_at || ''));
    const token = jwt.sign(
      { user_id: user.user_id, email: user.email, pwv: pwVersion, type: 'password_reset' },
      getResetJwtSecret(),
      { expiresIn: `${PASSWORD_RESET_EXPIRES_MINUTES}m` },
    );

    // Send email (required for real security). If SMTP isn't configured, still return generic success.
    try {
      const mailResult = await sendPasswordResetEmail({
        to: user.email,
        token,
        expiresMinutes: PASSWORD_RESET_EXPIRES_MINUTES,
      });
      if (!mailResult.ok) {
        // In dev, allow returning token for testing.
        if (String(process.env.RETURN_RESET_TOKEN || '').toLowerCase() === 'true') {
          return res.status(200).json({ ...genericResponse, token });
        }
        // Otherwise still return generic response to avoid enumeration.
        return res.status(200).json({
          ...genericResponse,
          note: isEmailConfigured() ? undefined : 'SMTP is not configured',
        });
      }
    } catch (mailError) {
      console.error('Password reset email send error:', mailError);
      if (String(process.env.RETURN_RESET_TOKEN || '').toLowerCase() === 'true') {
        return res.status(200).json({ ...genericResponse, token });
      }
    }

    return res.status(200).json(genericResponse);
  } catch (error) {
    console.error('requestPasswordReset error:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

const resetPassword = async (req, res) => {
  try {
    const { token, new_password } = req.body;
    if (!token || !new_password) {
      return res.status(400).json({ error: 'token and new_password are required' });
    }

    const secret = getResetJwtSecret();
    if (!secret) {
      return res.status(500).json({
        error: 'Password reset is not configured on the backend yet',
        hint: 'Missing PASSWORD_RESET_JWT_SECRET or JWT_SECRET in backend environment',
      });
    }

    let payload;
    try {
      payload = jwt.verify(String(token), secret);
    } catch (_) {
      return res.status(400).json({ error: 'Invalid or expired reset token' });
    }

    if (!payload || payload.type !== 'password_reset' || !payload.user_id || !payload.pwv) {
      return res.status(400).json({ error: 'Invalid or expired reset token' });
    }

    const userId = payload.user_id;
    const { data: user, error: userError } = await supabase
      .from('users')
      .select('user_id,password,updated_at')
      .eq('user_id', userId)
      .maybeSingle();

    if (userError) {
      console.error('Reset user lookup error:', userError);
      return res.status(500).json({ error: 'Database error' });
    }

    if (!user) {
      return res.status(400).json({ error: 'Invalid or expired reset token' });
    }

    const currentPwVersion = sha256(String(user.password || user.updated_at || ''));
    if (currentPwVersion !== payload.pwv) {
      return res.status(400).json({ error: 'Invalid or expired reset token' });
    }

    const hashedPassword = await bcrypt.hash(String(new_password), 10);
    const now = new Date().toISOString();

    const { error: updateError } = await supabase
      .from('users')
      .update({ password: hashedPassword, updated_at: now })
      .eq('user_id', userId);

    if (updateError) {
      console.error('Password update error:', updateError);
      return res.status(500).json({ error: 'Failed to update password' });
    }

    return res.status(200).json({ message: 'Password has been reset successfully' });
  } catch (error) {
    console.error('resetPassword error:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  register,
  login,
  googleAuth,
  signupHomeowner,
  signupProvider,
  requestPasswordReset,
  resetPassword,
};