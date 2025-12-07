const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');

// Applications 
router.get('/applications', adminController.getApplications);
router.get('/applications/:id', adminController.getApplicationById);
router.put('/applications/:id/approve', adminController.approveApplication);
router.put('/applications/:id/reject', adminController.rejectApplication);

// Reports 
router.get('/reports', adminController.getReports);
router.get('/reports/:id', adminController.getReportById);
router.put('/reports/:id/status', adminController.updateReportStatus);

// Statistics
router.get('/stats', adminController.getDashboardStats);

module.exports = router;