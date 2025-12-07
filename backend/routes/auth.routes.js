const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { validate } = require('../middlewares/validation.middleware');
const { 
  signupHomeownerValidator, 
  signupProviderValidator, 
  loginValidator 
} = require('../validators/auth.validator');

// Public routes
router.post(
  '/signup/homeowner', 
  (req, res, next) => {
    console.log('🔵 Route /signup/homeowner HIT');
    next();
  },
  // validate(signupHomeownerValidator),  // Temporarily disabled for testing
  authController.signupHomeowner
);

router.post(
  '/signup/provider', 
  validate(signupProviderValidator), 
  authController.signupProvider
);

router.post(
  '/login', 
  validate(loginValidator), 
  authController.login
);

router.post('/refresh-token', authController.refreshToken);

// Protected routes
router.post('/logout', authenticate, authController.logout);

module.exports = router;
