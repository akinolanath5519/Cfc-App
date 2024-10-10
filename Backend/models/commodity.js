const mongoose = require('mongoose');

// Define the commodity schema
const commoditySchema = new mongoose.Schema({
    name: {
        type: String,
        required: true, // Ensure name is required
    },
    rate: {
        type: Number,
        required: true, // Ensure rate is required
        min: 0, // Ensure rate is not negative
    },
    adminEmail: String,
});

// Create the Commodity model
const Commodity = mongoose.model('Commodity', commoditySchema);

// Export the Commodity model
module.exports = Commodity;
