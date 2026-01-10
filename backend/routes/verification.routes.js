const express = require('express');
const router = express.Router();

const verificationController = require('../controllers/verification.controller');

// NOTE: These endpoints intentionally do NOT require the /api/sp verified middleware.
// They allow pending service providers to submit verification documents.
router.post('/upload-document', verificationController.uploadDocument);
router.post('/submit', verificationController.submitVerification);
router.get('/status/:userId', verificationController.getVerificationStatus);

module.exports = router;
