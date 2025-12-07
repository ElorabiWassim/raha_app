const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/review.controller');
const { authenticate, isHomeowner } = require('../middlewares/auth.middleware');
const { validate } = require('../middlewares/validation.middleware');
const { addReviewValidator } = require('../validators/review.validator');

router.post('/reviews', authenticate, isHomeowner, validate(addReviewValidator), reviewController.addReview);

module.exports = router;