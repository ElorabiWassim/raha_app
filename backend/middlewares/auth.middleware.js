const supabase = require('../config/supabase');
const jwt = require('jsonwebtoken');

const authenticate = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');
    
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key');
        req.user = decoded; // { user_id, role, email, iat, exp }

        // Optionally fetch full user data if needed for downstream middleware
        // For efficiency, we rely on the payload unless we need fresh status
        // But for `isServiceProvider` we might need `req.user.user_id` which we have.
        
        // Let's attach the full user object to maintain compatibility with existing logic
        // or just ensure req.user has what's needed.
        // Existing logic used `req.user.role` and `req.user.user_id`.
        
        // Wait, decoded payload from `generateTokens` is: { user_id, role, email }
        // So req.user.user_id and req.user.role work directly!
        
        next();
    } catch (err) {
        return res.status(401).json({ error: 'Invalid or expired token' });
    }
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

module.exports = { authenticate, isServiceProvider, isHomeowner };