const express = require('express');
const router = express.Router();
const ClientController = require('../controller/ClientController');

// Create new client
router.post('/clients', ClientController.createClient);

// Get all clients
router.get('/clients', ClientController.getAllClients);

// Get client by ID
router.get('/clients/:id', ClientController.getClientById);

// Update client
router.put('/clients/:id', ClientController.updateClient);

// Delete client
router.delete('/clients/:id', ClientController.deleteClient);

module.exports = router;
