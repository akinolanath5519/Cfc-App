const mongoose = require('mongoose');

// Define the Sack schema
const sackSchema = new mongoose.Schema({
    supplierName: {
        type: String,
        required: true, // Ensure supplierName is required
    },
    date: {
        type: Date,
        required: true, // Ensure date is required
    },
    bagsCollected: {
        type: Number,
        required: true, // Ensure bagsCollected is required
        min: 0, // Ensure no negative values
    },
    bagsReturned: {
        type: Number,
        required: true, // Ensure bagsReturned is required
        min: 0, // Ensure no negative values
    },
    bagsRemaining: {
        type: Number,
        required: true, // Ensure bagsRemaining is calculated and required
        min: 0, // Ensure no negative values
    },
    adminEmail: String, // Associate sack with the admin who created it
});

// Create the Sack model
const Sack = mongoose.model('Sack', sackSchema);

// Export the Sack model
module.exports = Sack;
