const supabase = require('../config/supabase');

const authenticate = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    // Check for hardcoded admin token
    if (token.startsWith('admin-hardcoded-token-')) {
      console.log('Admin hardcoded token detected');

      // Fetch admin user from database
      const { data: adminData, error: adminError } = await supabase
        .from('users')
        .select('*')
        .eq('email', 'admin@gmail.com')
        .single();

      if (adminError || !adminData) {
        console.error('Admin user not found in database');
        return res.status(404).json({ error: 'Admin user not found' });
      }

      req.user = adminData;
      return next();
    }

    const { data: { user }, error } = await supabase.auth.getUser(token);

    if (error) {
      console.error('Supabase getUser error:', error.message);
    }

    if (error || !user) {
      return res.status(401).json({ error: 'Invalid token' });
    }

    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('*')
      .eq('user_id', user.id)
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