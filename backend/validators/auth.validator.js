const { body } = require('express-validator');

const signupHomeownerValidator = [
  body('email').isEmail().withMessage('Invalid email format'),
  body('password')
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters long'),
  body('fullName').notEmpty().withMessage('Full Name is required'),
  body('phoneNumber').notEmpty().withMessage('Phone Number is required'),
  body('homeAddress').notEmpty().withMessage('Home Address is required'),
  body('dateOfBirth').isISO8601().withMessage('Date of Birth must be a valid date (YYYY-MM-DD)'),
];

const signupProviderValidator = [
  body('email').isEmail().withMessage('Invalid email format'),
  body('password')
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters long'),
  body('fullName').notEmpty().withMessage('Full Name is required'),
  body('phoneNumber').notEmpty().withMessage('Phone Number is required'),
  body('workingAddress').notEmpty().withMessage('Working Address is required'),
  body('dateOfBirth').isISO8601().withMessage('Date of Birth must be a valid date'),
  // serviceType is optional or required depending on logic, let's make it required for clarity
  body('serviceType').notEmpty().withMessage('Service Type is required'),
];

const loginValidator = [
  body('email').isEmail().withMessage('Invalid email format'),
  body('password').notEmpty().withMessage('Password is required'),
];

module.exports = {
  signupHomeownerValidator,
  signupProviderValidator,
  loginValidator,
};
