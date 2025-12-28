const express = require('express');
const router = express.Router();
const authController = require('../controllers/login.controller');
const { validate } = require('../middlewares/validation.middleware');
const { loginValidator, registerValidator } = require('../validators/auth.validator');

router.post('/register', authController.register);
router.post('/login', validate(loginValidator), authController.login);
router.post('/google', authController.googleAuth);

// Signup endpoints used by Flutter SignupCubit/AuthApi
router.post('/signup/homeowner', validate(registerValidator), authController.signupHomeowner);
router.post('/signup/provider', validate(registerValidator), authController.signupProvider);

module.exports = router;