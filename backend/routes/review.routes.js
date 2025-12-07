const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/review.controller');

// Add review (homeowner)
router.post('/reviews', reviewController.addReview);

module.exports = router;