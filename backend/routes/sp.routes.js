const express = require('express');
const router = express.Router();
const spController = require('../controllers/sp.controller');
const { validate } = require('../middlewares/validation.middleware');
const { spIdValidator } = require('../validators/review.validator');

// Public routes - no authentication required
router.get('/reviews/:spId', validate(spIdValidator), spController.getReviewsForSP);
router.get('/rating/:spId', validate(spIdValidator), spController.getAverageRating);

module.exports = router;
