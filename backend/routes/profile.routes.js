const express = require('express');
const router = express.Router();
const multer = require('multer');
const profileController = require('../controllers/profile.controller');
const { authenticate } = require('../middlewares/auth.middleware');

const upload = multer({ storage: multer.memoryStorage() });

// All routes require authentication
router.use(authenticate);

router.get('/', profileController.getProfile);
router.put('/', profileController.updateProfile);
router.put('/image', upload.single('image'), profileController.updateProfilePicture);
router.put('/password', profileController.changePassword);
router.delete('/account', profileController.deleteAccount);
router.get('/profile', profileController.getServiceProviderProfile);
module.exports = router;
