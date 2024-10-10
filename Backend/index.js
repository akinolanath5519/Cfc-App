const express = require('express');
const mongoose = require('mongoose');
const authRoutes = require('./routes/auth');
const supplierRoutes = require('./routes/supplier');
const commodityRoutes = require('./routes/commodity');
const sackRoutes = require('./routes/sack');
const transactionRoutes = require('./routes/transaction');


const app = express();
app.use(express.json());

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/AgriPay', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => {
    console.log('Connected to MongoDB');
}).catch((err) => console.log(err));

// Use routes without URL prefixes
app.use(authRoutes);  // Assuming auth routes are defined as paths like '/register-admin', '/register-standard', etc.
app.use(supplierRoutes);
app.use(commodityRoutes);// Assuming supplier routes are defined as paths like '/supplier', etc.
app.use(sackRoutes)
app.use(transactionRoutes)



// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

module.exports = app;
