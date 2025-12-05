const jwt = require('jsonwebtoken');
const supabase = require('../config/supabase');

const authenticate = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const token = authHeader.replace('Bearer ', '');

    // Verify YOUR custom JWT token
    let decoded;
    try {
      decoded = jwt.verify(token, process.env.JWT_SECRET);
    } catch (jwtError) {
      if (jwtError.name === 'TokenExpiredError') {
        return res.status(401).json({ error: 'Token expired' });
      }
      if (jwtError.name === 'JsonWebTokenError') {
        return res.status(401).json({ error: 'Invalid token' });
      }
      throw jwtError;
    }

    // Get user data from database using the user_id from token
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('*')
      .eq('user_id', decoded.user_id)
      .single();

    if (userError || !userData) {
      return res.status(404).json({ error: 'User not found' });
    }

    req.user = userData;
    next();
  } catch (error) {
    console.error('Authentication error:', error);
    res.status(500).json({ error: 'Authentication failed' });
  }
};

const isServiceProvider = async (req, res, next) => {
  try {
    if (req.user.role !== 'service_provider') {
      return res.status(403).json({ error: 'Access denied. Service provider role required.' });
    }

    // Get service provider data using user_id (not sp_id)
    const { data: spData, error } = await supabase
      .from('service_providers')
      .select('*')
      .eq('sp_id', req.user.user_id)
      .single();

    if (error || !spData) {
      return res.status(404).json({ error: 'Service provider profile not found' });
    }

    req.serviceProvider = spData;
    next();
  } catch (error) {
    console.error('Service provider verification error:', error);
    res.status(500).json({ error: 'Authorization failed' });
  }
};

const isHomeowner = async (req, res, next) => {
  try {
    if (req.user.role !== 'homeowner') {
      return res.status(403).json({ error: 'Access denied. Homeowner role required.' });
    }

    // Get homeowner data using user_id
    const { data: homeownerData, error } = await supabase
      .from('homeowners')
      .select('*')
      .eq('homeowner_id', req.user.user_id)
      .single();

    if (error || !homeownerData) {
      return res.status(404).json({ error: 'Homeowner profile not found' });
    }

    req.homeowner = homeownerData;
    next();
  } catch (error) {
    console.error('Homeowner verification error:', error);
    res.status(500).json({ error: 'Authorization failed' });
  }
};

module.exports = { authenticate, isServiceProvider, isHomeowner };