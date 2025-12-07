const { body, param, query } = require('express-validator');

// Application ID validator
const applicationIdValidator = [
  param('id')
    .notEmpty()
    .withMessage('Application ID is required')
    .isUUID()
    .withMessage('Application ID must be a valid UUID'),
];

// Report ID validator
const reportIdValidator = [
  param('id')
    .notEmpty()
    .withMessage('Report ID is required')
    .isUUID()
    .withMessage('Report ID must be a valid UUID'),
];

// Update report status validator
const updateReportStatusValidator = [
  param('id')
    .notEmpty()
    .withMessage('Report ID is required')
    .isUUID()
    .withMessage('Report ID must be a valid UUID'),
  body('status')
    .notEmpty()
    .withMessage('status is required')
    .isIn(['pending', 'under_review', 'resolved', 'dismissed'])
    .withMessage('status must be one of: pending, under_review, resolved, dismissed'),
  body('admin_notes')
    .optional()
    .isString()
    .withMessage('admin_notes must be a string')
    .trim()
    .isLength({ max: 1000 })
    .withMessage('admin_notes must not exceed 1000 characters'),
];

// Query filters validator
const queryFiltersValidator = [
  query('status')
    .optional()
    .isString()
    .withMessage('status must be a string'),
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('page must be a positive integer'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('limit must be between 1 and 100'),
];

module.exports = {
  applicationIdValidator,
  reportIdValidator,
  updateReportStatusValidator,
  queryFiltersValidator,
};
