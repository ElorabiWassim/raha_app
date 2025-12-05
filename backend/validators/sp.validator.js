const { body, query, param } = require('express-validator');

const addServiceValidator = [
  body('name').trim().notEmpty().withMessage('Service name is required'),
  body('description').trim().notEmpty().withMessage('Description is required'),
  body('category_id').isUUID().withMessage('Valid category ID is required'),
  body('price_type').isIn(['fixed', 'hourly', 'quote']).withMessage('Invalid price type'),
  body('price_amount').optional().isFloat({ min: 0 }).withMessage('Price must be positive'),
];

const editServiceValidator = [
  param('serviceId').isUUID().withMessage('Valid service ID is required'),
  body('name').optional().trim().notEmpty().withMessage('Service name cannot be empty'),
  body('description').optional().trim().notEmpty().withMessage('Description cannot be empty'),
  body('category_id').optional().isUUID().withMessage('Valid category ID is required'),
  body('price_type').optional().isIn(['fixed', 'hourly', 'quote']).withMessage('Invalid price type'),
  body('price_amount').optional().isFloat({ min: 0 }).withMessage('Price must be positive'),
];

const demandQueryValidator = [
  query('category_id').optional().isUUID().withMessage('Valid category ID required'),
  query('status').optional().isIn(['open', 'closed', 'expired']).withMessage('Invalid status'),
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be positive integer'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1-100'),
];

const sendOfferValidator = [
  body('demand_id').isUUID().withMessage('Valid demand ID is required'),
  body('sp_id').isUUID().withMessage('Valid service provider ID is required'),
  body('message').trim().notEmpty().withMessage('Message is required'),
  body('proposed_price').isFloat({ min: 0 }).withMessage('Proposed price must be positive'),
  body('proposed_date').isISO8601().withMessage('Valid date is required'),
];

const bookingActionValidator = [
  param('bookingId').isUUID().withMessage('Valid booking ID is required'),
];

const wilayaParamValidator = [
  param('wilaya')
    .trim()
    .notEmpty()
    .withMessage('Wilaya is required')
    .isLength({ min: 2, max: 50 })
    .withMessage('Wilaya must be 2-50 characters'),
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be positive integer'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('Limit must be between 1-100')
];

const categoryParamValidator = [
  param('categoryId')
    .isUUID()
    .withMessage('Valid category ID is required'),
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be positive integer'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('Limit must be between 1-100')
];

const searchQueryValidator = [
  query('query')
    .trim()
    .notEmpty()
    .withMessage('Search query is required')
    .isLength({ min: 2, max: 100 })
    .withMessage('Search query must be 2-100 characters'),
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be positive integer'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('Limit must be between 1-100')
];


module.exports = {
  addServiceValidator,
  editServiceValidator,
  demandQueryValidator,
  sendOfferValidator,
  bookingActionValidator,
  wilayaParamValidator,
  categoryParamValidator,
  searchQueryValidator
};
