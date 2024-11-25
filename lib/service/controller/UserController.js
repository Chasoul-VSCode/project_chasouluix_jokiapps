const connection = require('../config/database');
const bcrypt = require('bcrypt');

const register = async (req, res) => {
    const { username, email, password } = req.body;

    // Input validation
    if (!username || !email || !password) {
        return res.status(400).json({
            success: false,
            message: 'Username, email and password are required'
        });
    }

    try {
        // Check if username already exists
        connection.query(
            'SELECT * FROM users WHERE username = ? OR email = ?',
            [username, email],
            async (err, existingUsers) => {
                if (err) {
                    return res.status(500).json({
                        success: false,
                        message: 'Registration failed',
                        error: err.message
                    });
                }

                if (existingUsers.length > 0) {
                    return res.status(400).json({
                        success: false,
                        message: 'Username or email already exists'
                    });
                }

                // Hash password
                const saltRounds = 10;
                const hashedPassword = await bcrypt.hash(password, saltRounds);

                // Insert new user
                connection.query(
                    'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
                    [username, email, hashedPassword],
                    (err, result) => {
                        if (err) {
                            return res.status(500).json({
                                success: false,
                                message: 'Registration failed',
                                error: err.message
                            });
                        }

                        res.status(201).json({
                            success: true,
                            message: 'User registered successfully',
                            user: {
                                id: result.insertId,
                                username,
                                email,
                                created_at: new Date(),
                                updated_at: new Date()
                            }
                        });
                    }
                );
            }
        );

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Registration failed',
            error: error.message
        });
    }
};

const login = async (req, res) => {
    const { username, password } = req.body;

    // Input validation
    if (!username || !password) {
        return res.status(400).json({
            success: false,
            message: 'Username and password are required'
        });
    }

    try {
        // Get user from database
        connection.query(
            'SELECT * FROM users WHERE username = ?',
            [username],
            async (err, users) => {
                if (err) {
                    return res.status(500).json({
                        success: false,
                        message: 'Login failed',
                        error: err.message
                    });
                }

                if (users.length === 0) {
                    return res.status(401).json({
                        success: false,
                        message: 'Invalid username or password'
                    });
                }

                const user = users[0];

                // Compare password
                const passwordMatch = await bcrypt.compare(password, user.password);

                if (!passwordMatch) {
                    return res.status(401).json({
                        success: false,
                        message: 'Invalid username or password'
                    });
                }

                res.status(200).json({
                    success: true,
                    message: 'Login successful',
                    user: {
                        id: user.id,
                        username: user.username,
                        email: user.email,
                        created_at: user.created_at,
                        updated_at: user.updated_at
                    }
                });
            }
        );

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Login failed',
            error: error.message
        });
    }
};

module.exports = {
    register,
    login
};
