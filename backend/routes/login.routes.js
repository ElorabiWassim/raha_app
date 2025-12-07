const express = require('express');
const router = express.Router();
const spController = require('../controllers/login.controller');
router.post('/register', spController.register);
router.post('/login', spController.login);
module.exports = router;