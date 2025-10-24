// Import express
const express = require('express');
const app = express();
const port = 8080;//port defined here

// Define routes
app.get('/', (req, res) => res.send('Hello, App running on Version 1.0'));
app.get('/health', (req, res) => res.send('OK'));

// Start server
app.listen(port, () => console.log(`App running on port ${port}`));