const express = require('express');
const router = express.Router();
const spController = require('../controllers/sp.controller');
const { authenticate, isServiceProvider } = require('../middlewares/auth.middleware');
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });
const { validate, validateQuery } = require('../middlewares/validation.middleware');
const { 
  addServiceValidator, 
  editServiceValidator,
  demandQueryValidator,
  sendOfferValidator,
  bookingActionValidator,wilayaParamValidator,categoryParamValidator,
  searchQueryValidator
} = require('../validators/sp.validator');

router.use(authenticate);
router.use(isServiceProvider);

router.post('/services', validate(addServiceValidator), spController.addService);
router.put('/services/:serviceId', validate(editServiceValidator), spController.editService);
router.delete('/services/:serviceId', spController.deleteService);
router.get('/services/my', spController.getMyServices);
router.post('/categories', spController.createCategory);
router.get('/services/:serviceId', spController.getServiceById);
router.post('/services/:service_id/images',upload.array('images', 10), spController.uploadServiceImages);
router.get('/services/:service_id/images', spController.getServiceImages);
router.delete('/images/:image_id',  spController.deleteServiceImage);
router.put('/images/:image_id',  upload.single('image'),spController.updateServiceImage);

// Demands
router.get('/demands', validateQuery(demandQueryValidator), spController.getDemands);
router.get('/demands/wilaya/:wilaya', validate(wilayaParamValidator), spController.getDemandsByWilaya);
router.get('/demands/category/:categoryId', validate(categoryParamValidator), spController.getDemandsByCategory);
router.get('/demands/search', validateQuery(searchQueryValidator), spController.searchDemandsByTitle);
// Offers
router.post('/offers', validate(sendOfferValidator), spController.sendOffer);
router.get('/offers/my', spController.getMyOffers);
router.get('/offers/:offerId', spController.getOfferDetails);

// Bookings
router.get('/bookings', spController.getMyBookings);
router.get('/bookings/history', spController.getBookingHistory);
router.put('/bookings/:bookingId/accept', spController.acceptBooking);
router.put('/bookings/:bookingId/decline', spController.declineBooking);
router.put('/bookings/:bookingId/complete', spController.completeBooking);

// Subscription
router.get('/subscription/current', spController.getCurrentSubscription);
router.post('/subscription/upgrade', spController.upgradeSubscription);

// Profile
router.get('/profile', spController.getProfile);
router.put('/profile', spController.updateProfile);
router.put('/profile/image', upload.single('image'), spController.updateProfilePicture);

module.exports = router;