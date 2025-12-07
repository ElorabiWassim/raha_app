const express = require('express');
const router = express.Router();
const profileController = require('../controllers/profile.controller');
const { authenticate } = require('../middlewares/auth.middleware');

// All routes require authentication
router.use(authenticate);

router.get('/', profileController.getProfile);
router.put('/', profileController.updateProfile);
router.put('/password', profileController.changePassword);
router.delete('/account', profileController.deleteAccount);

module.exports = router;
