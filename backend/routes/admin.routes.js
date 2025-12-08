const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');
const { authenticate, isAdmin } = require('../middlewares/auth.middleware');
const { validate } = require('../middlewares/validation.middleware');
const {
  applicationIdValidator,
  reportIdValidator,
  updateReportStatusValidator,
  queryFiltersValidator,
} = require('../validators/admin.validator');

router.use(authenticate);
router.use(isAdmin);
router.get('/applications', validate(queryFiltersValidator), adminController.getApplications);
router.get('/applications/:id', validate(applicationIdValidator), adminController.getApplicationById);
router.put('/applications/:id/approve', validate(applicationIdValidator), adminController.approveApplication);
router.put('/applications/:id/reject', validate(applicationIdValidator), adminController.rejectApplication);

router.get('/reports', validate(queryFiltersValidator), adminController.getReports);
router.get('/reports/:id', validate(reportIdValidator), adminController.getReportById);
router.put('/reports/:id/status', validate(updateReportStatusValidator), adminController.updateReportStatus);

router.get('/stats', adminController.getDashboardStats);

module.exports = router;