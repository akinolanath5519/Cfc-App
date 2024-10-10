const mongoose = require('mongoose');

// Define the Transaction schema
const transactionSchema = new mongoose.Schema({
    weight: {
        type: Number,
        required: true, // Ensure weight is required
        min: 0, // Ensure no negative values
    },
    unit: {
        type: String,
        required: true, // Ensure unit is required
    },
    price: {
        type: Number,
        required: true, // Ensure price is required
        min: 0, // Ensure no negative values
    },
    commodityName: {
        type: String,
        required: true, // Ensure commodityName is required
    },
    supplierName: {
        type: String,
        required: true, // Ensure supplierName is required
    },
    transactionDate: {
        type: Date,
        required: true, // Ensure transactionDate is required
    },
    adminEmail: String,
});

// Create the Transaction model
const Transaction = mongoose.model('Transaction', transactionSchema);

// Export the Transaction model
module.exports = Transaction;
