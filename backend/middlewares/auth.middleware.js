const supabase = require('../config/supabase');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const authenticate = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    console.log('🔐 Authentication attempt');
    console.log('Token present:', !!token);
    if (token) {
      console.log('Token preview:', token.substring(0, 20) + '...');
    }

    if (!token) {
      console.log('❌ No token provided');
      return res.status(401).json({ error: 'No token provided' });
    }

    // Try to verify JWT token first (for both admin and regular users)
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      console.log('✅ JWT verification successful:', decoded);

      // If token is valid, fetch user from database
      const { data: userData, error: userError } = await supabase
        .from('users')
        .select('*')
        .eq('user_id', decoded.user_id)
        .single();

      if (!userError && userData) {
        console.log('✅ User found in database:', userData.email);
        req.user = userData;
        return next();
      }

      // If user not in DB but token is valid and role is admin, allow it
      if (decoded.role === 'admin') {
        console.log('✅ Admin JWT token verified');
        req.user = {
          user_id: decoded.user_id,
          email: decoded.email,
          full_name: 'Admin',
          role: 'admin',
          phone_number: null,
          created_at: new Date().toISOString()
        };
        return next();
      }

      console.log('❌ User not found in database for decoded token');
      return res.status(404).json({ error: 'User not found' });

    } catch (jwtError) {
      console.log('⚠️ JWT verification failed:', jwtError.message);
      console.log('Trying Supabase auth fallback...');
      // If JWT verification fails, try Supabase auth as fallback
    }

    // Fallback: Try Supabase auth
    const { data: { user }, error } = await supabase.auth.getUser(token);

    console.log('Supabase getUser result:', { user: !!user, error: error?.message });

    if (error) {
      console.error('❌ Supabase getUser error:', error.message);
    }

    if (error || !user) {
      console.log('❌ Invalid token - both JWT and Supabase auth failed');
      return res.status(401).json({ error: 'Invalid token' });
    }

    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('*')
      .eq('user_id', user.id)
      .single();

    if (userError || !userData) {
      console.log('❌ User not found after Supabase auth');
      return res.status(404).json({ error: 'User not found' });
    }

    console.log('✅ Supabase auth successful:', userData.email);
    req.user = userData;
    next();
  } catch (error) {
    console.error('❌ Authentication error:', error);
    res.status(500).json({ error: 'Authentication failed' });
  }
};

const isServiceProvider = async (req, res, next) => {
  try {
    if (req.user.role !== 'service_provider') {
      return res.status(403).json({ error: 'Access denied. Service provider role required.' });
    }
    const { data: spData, error } = await supabase
      .from('service_providers')
      .select('*')
      .eq('sp_id', req.user.user_id)
      .single();

    if (error || !spData) {
      return res.status(404).json({ error: 'Service provider profile not found' });
    }


    if (spData.verification_status !== 'verified') {
      return res.status(403).json({
        error: 'Service provider not verified',
        status: spData.verification_status
      });
    }

    req.serviceProvider = spData;
    next();
  } catch (error) {
    console.error('Service provider verification error:', error);
    res.status(500).json({ error: 'Authorization failed' });
  }
};

const isHomeowner = (req, res, next) => {
  if (req.user.role !== 'homeowner') {
    return res.status(403).json({ error: 'Access denied. Homeowner role required.' });
  }
  next();
};

const isAdmin = (req, res, next) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Access denied. Admin role required.' });
  }
  next();
};

module.exports = { authenticate, isServiceProvider, isHomeowner, isAdmin };