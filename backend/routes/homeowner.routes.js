const express = require('express');
const router = express.Router();
const hoController = require('../controllers/ho.controller');
const { authenticate, isHomeowner } = require('../middlewares/auth.middleware');
router.post('/demands', authenticate, isHomeowner, hoController.createDemand);
module.exports = router;