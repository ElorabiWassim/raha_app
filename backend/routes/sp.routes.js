const express = require('express');
const router = express.Router();
const spController = require('../controllers/sp.controller');
const { validate } = require('../middlewares/validation.middleware');
const { spIdValidator } = require('../validators/review.validator');

// Public routes - no authentication required for viewing SP reviews and ratings
// Get reviews for a specific service provider
router.get('/reviews/:spId', validate(spIdValidator), spController.getReviewsForSP);

// Get average rating for a service provider
router.get('/rating/:spId', validate(spIdValidator), spController.getAverageRating);

module.exports = router;
