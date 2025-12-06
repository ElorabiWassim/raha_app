const express = require('express');
const router = express.Router();
const hoController = require('../controllers/homeowner.controller');
const { authenticate, isHomeowner} = require('../middlewares/auth.middleware');
router.use(authenticate);
router.use(isHomeowner);
router.get('/reviews/:sp_id', hoController.getreviewsById);
router.get('/services/:sp_id', hoController.getServiceByspId);
module.exports = router;