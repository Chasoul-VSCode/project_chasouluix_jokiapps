const express = require('express');
const router = express.Router();
const connection = require('../config/database');

// Route to test database connection
router.get('/conn', (req, res) => {
  if (connection.state === 'authenticated') {
    res.status(200).json({
      success: true,
      message: 'Database connection successful'
    });
  } else {
    res.status(500).json({
      success: false,
      message: 'Database connection failed'
    });
  }
});

module.exports = router;
