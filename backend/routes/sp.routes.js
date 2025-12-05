const express = require('express');
const router = express.Router();
const spController = require('../controllers/sp.controller');

// Test route
router.get('/test', (req, res) => {
    res.json({ message: 'SP routes are working!' });
});

// Your actual routes will go here
// Example:
// router.get('/profile', spController.getProfile);
// router.put('/profile', spController.updateProfile);

module.exports = router; // THIS LINE IS CRITICAL!