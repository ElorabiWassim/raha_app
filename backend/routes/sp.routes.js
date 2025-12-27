const express = require('express');
const router = express.Router();
const spController = require('../controllers/sp.controller');
const { authenticate, isServiceProvider } = require('../middlewares/auth.middleware');
const { validate } = require('../middlewares/validation.middleware');
const { addServiceValidator, editServiceValidator } = require('../validators/sp.validator');
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });



// Protected routes - authentication required
router.use(authenticate);
router.use(isServiceProvider);

// Service management
router.post('/services', validate(addServiceValidator), spController.addService);
router.put('/services/:serviceId', validate(editServiceValidator), spController.editService);
router.delete('/services/:serviceId', spController.deleteService);
router.get('/services/my', spController.getMyServices);
router.post('/categories', spController.createCategory);
router.get('/services/:serviceId', spController.getServiceById);
router.post('/services/:service_id/images', upload.array('images', 10), spController.uploadServiceImages);
router.get('/services/:service_id/images', spController.getServiceImages);
router.delete('/images/:image_id', spController.deleteServiceImage);
router.put('/images/:image_id', upload.single('image'), spController.updateServiceImage);

// Demands management
router.get('/demands', spController.getDemands);
router.get('/demands/category/:categoryId', spController.getDemandsByCategory);
router.get('/demands/wilaya/:wilaya', spController.getDemandsByWilaya);
router.get('/demands/title',spController.searchDemandsByTitle)
router.get('/demands/:demandId', spController.getDemandDetails);
router.post('/plans/subscribe', spController.upgradeSubscription);
router.get('/plans', spController.getSubscriptionPlans);
// Offers management
router.post('/offers/send', spController.sendOffer);
router.get('/offers/my', spController.getMyOffers);

// Bookings management
router.get('/bookings', spController.getMyBookings);
router.get('/bookings/history', spController.getBookingHistory);
router.put('/bookings/:bookingId/accept', spController.acceptBooking);
router.put('/bookings/:bookingId/decline', spController.declineBooking);
router.put('/bookings/:bookingId/complete', spController.completeBooking);
router.put('/profiles/update', spController.updateProfile);
router.put('/profiles/update/image', upload.single('image'), spController.updateProfilePicture);


module.exports = router;
