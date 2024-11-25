const connection = require('../config/database');

const testConnection = async (req, res) => {
  try {
    res.status(200).json({
      success: true,
      message: 'Database connection successful'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Database connection failed',
      error: error.message
    });
  }
};

module.exports = {
  testConnection
};
