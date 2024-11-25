const express = require('express');
const router = express.Router();
const UserController = require('../controller/UserController');
const db = require('../config/database');

// Route for user registration
router.post('/register', UserController.register);

// Route for user login 
router.post('/login', UserController.login);

module.exports = router;
