const connection = require('../config/database');

// Create new client
const createClient = async (req, res) => {
    const { username, email, nama_project, detail_project, total_harga } = req.body;
    const status_pembayaran = 'pending';
    const harga_dibayar = 0;

    // Input validation
    if (!username || !email || !nama_project || !detail_project || !total_harga) {
        return res.status(400).json({
            success: false,
            message: 'All fields are required'
        });
    }

    try {
        connection.query(
            'INSERT INTO clients (username, email, nama_project, detail_project, total_harga, harga_dibayar, status_pembayaran) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [username, email, nama_project, detail_project, total_harga, harga_dibayar, status_pembayaran],
            (err, result) => {
                if (err) {
                    return res.status(500).json({
                        success: false,
                        message: 'Failed to create client',
                        error: err.message
                    });
                }

                res.status(201).json({
                    success: true,
                    message: 'Client created successfully',
                    data: {
                        id_client: result.insertId,
                        username,
                        email,
                        nama_project,
                        detail_project,
                        total_harga,
                        harga_dibayar,
                        status_pembayaran,
                        created_at: new Date(),
                        updated_at: new Date()
                    }
                });
            }
        );

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Failed to create client',
            error: error.message
        });
    }
};

// Get all clients
const getAllClients = async (req, res) => {
    try {
        connection.query('SELECT * FROM clients ORDER BY created_at DESC', (err, clients) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: 'Failed to fetch clients',
                    error: err.message
                });
            }

            res.status(200).json({
                success: true,
                data: clients
            });
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Failed to fetch clients',
            error: error.message
        });
    }
};

// Get client by ID
const getClientById = async (req, res) => {
    const { id } = req.params;

    try {
        connection.query(
            'SELECT * FROM clients WHERE id_client = ?',
            [id],
            (err, clients) => {
                if (err) {
                    return res.status(500).json({
                        success: false,
                        message: 'Failed to fetch client',
                        error: err.message
                    });
                }

                if (clients.length === 0) {
                    return res.status(404).json({
                        success: false,
                        message: 'Client not found'
                    });
                }

                res.status(200).json({
                    success: true,
                    data: clients[0]
                });
            }
        );

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Failed to fetch client',
            error: error.message
        });
    }
};

// Update client
const updateClient = async (req, res) => {
    const { id } = req.params;
    const { username, email, nama_project, detail_project, total_harga, harga_dibayar, status_pembayaran } = req.body;

    // Validate status_pembayaran enum values
    if (!['pending', 'partial', 'paid'].includes(status_pembayaran)) {
        return res.status(400).json({
            success: false,
            message: 'Invalid status_pembayaran value. Must be pending, partial, or paid'
        });
    }

    try {
        connection.query(
            'UPDATE clients SET username = ?, email = ?, nama_project = ?, detail_project = ?, total_harga = ?, harga_dibayar = ?, status_pembayaran = ? WHERE id_client = ?',
            [username, email, nama_project, detail_project, total_harga, harga_dibayar, status_pembayaran, id],
            (err, result) => {
                if (err) {
                    return res.status(500).json({
                        success: false,
                        message: 'Failed to update client',
                        error: err.message
                    });
                }

                if (result.affectedRows === 0) {
                    return res.status(404).json({
                        success: false,
                        message: 'Client not found'
                    });
                }

                res.status(200).json({
                    success: true,
                    message: 'Client updated successfully',
                    data: {
                        id_client: id,
                        username,
                        email,
                        nama_project,
                        detail_project,
                        total_harga,
                        harga_dibayar,
                        status_pembayaran,
                        updated_at: new Date()
                    }
                });
            }
        );

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Failed to update client',
            error: error.message
        });
    }
};

// Delete client
const deleteClient = async (req, res) => {
    const { id } = req.params;

    try {
        connection.query(
            'DELETE FROM clients WHERE id_client = ?',
            [id],
            (err, result) => {
                if (err) {
                    return res.status(500).json({
                        success: false,
                        message: 'Failed to delete client',
                        error: err.message
                    });
                }

                if (result.affectedRows === 0) {
                    return res.status(404).json({
                        success: false,
                        message: 'Client not found'
                    });
                }

                res.status(200).json({
                    success: true,
                    message: 'Client deleted successfully'
                });
            }
        );

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Failed to delete client',
            error: error.message
        });
    }
};

module.exports = {
    createClient,
    getAllClients,
    getClientById,
    updateClient,
    deleteClient
};
