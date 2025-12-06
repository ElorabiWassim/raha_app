const express = require('express');
const router = express.Router();
const spController = require('../controllers/sp.controller');
const { authenticate, isServiceProvider } = require('../middlewares/auth.middleware');
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
// Service management
router.post('/services', validate(addServiceValidator), spController.addService);
router.put('/services/:serviceId', validate(editServiceValidator), spController.editService);
router.delete('/services/:serviceId', spController.deleteService);
router.get('/services/my', spController.getMyServices);
router.post('/categories', spController.createCategory);
router.get('/services/:serviceId', spController.getServiceById);

// Demands
router.get('/demands', validateQuery(demandQueryValidator), spController.getDemands);
router.get('/demands/:demandId', spController.getDemandDetails);
// 1. Get demands by wilaya
router.get('/demands/wilaya/:wilaya', validate(wilayaParamValidator), spController.getDemandsByWilaya);
router.get('/demands/category/:categoryId', validate(categoryParamValidator), spController.getDemandsByCategory);
router.get( '/demands/search', validateQuery(searchQueryValidator), spController.searchDemandsByTitle);
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

module.exports = router;