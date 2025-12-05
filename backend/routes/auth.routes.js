const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const { authenticate } = require('../middlewares/auth.middleware');

// Public routes
router.post('/signup/homeowner', authController.signupHomeowner);
router.post('/signup/provider', authController.signupProvider);
router.post('/login', authController.login);
router.post('/refresh-token', authController.refreshToken);

// Protected routes
router.post('/logout', authenticate, authController.logout);

module.exports = router;
