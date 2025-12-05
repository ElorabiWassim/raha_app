const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');

// === Applications (Service Provider Verification) ===
router.get('/applications', adminController.getApplications);
router.get('/applications/:id', adminController.getApplicationById);
router.put('/applications/:id/approve', adminController.approveApplication);
router.put('/applications/:id/reject', adminController.rejectApplication);

// === Reports Management ===
router.get('/reports', adminController.getReports);
router.get('/reports/:id', adminController.getReportById);
router.put('/reports/:id/status', adminController.updateReportStatus);

// === Statistics/Dashboard ===
router.get('/stats', adminController.getDashboardStats);

// === Reviews Management ===
router.get('/reviews', adminController.getReviews);
router.delete('/reviews/:id', adminController.deleteReview);

module.exports = router;