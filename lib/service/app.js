const express = require('express');
const app = express();
const port = 3000;
const connection = require('./config/database');

const connRoutes = require('./routes/ConnRoutes');
const userRoutes = require('./routes/UserRoutes');
const clientRoutes = require('./routes/ClientRoutes');

// Middleware for parsing JSON bodies
app.use(express.json());

// Basic route
app.get('/', (req, res) => {
  res.send('Hello World!');
});
app.use('/api', connRoutes);
app.use('/api', userRoutes);
app.use('/api', clientRoutes);
// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});