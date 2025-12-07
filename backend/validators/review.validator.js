const { body, param } = require('express-validator');

// Review submission validator
const addReviewValidator = [
  body('booking_id')
    .notEmpty()
    .withMessage('booking_id is required')
    .isUUID()
    .withMessage('booking_id must be a valid UUID'),
  body('sp_id')
    .notEmpty()
    .withMessage('sp_id is required')
    .isUUID()
    .withMessage('sp_id must be a valid UUID'),
  body('rating')
    .notEmpty()
    .withMessage('rating is required')
    .isFloat({ min: 0, max: 5 })
    .withMessage('rating must be between 0 and 5'),
  body('review_text')
    .optional()
    .isString()
    .withMessage('review_text must be a string')
    .trim()
    .isLength({ max: 2000 })
    .withMessage('review_text must not exceed 2000 characters'),
];

// SP ID validator
const spIdValidator = [
  param('spId')
    .notEmpty()
    .withMessage('spId is required')
    .isUUID()
    .withMessage('spId must be a valid UUID'),
];

module.exports = {
  addReviewValidator,
  spIdValidator,
};
