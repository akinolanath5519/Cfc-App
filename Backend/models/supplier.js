const mongoose = require('mongoose');

const supplierSchema = new mongoose.Schema({
    name: String,
    contact: {
        type: String,
        required: true,
        validate: {
            validator: function(v) {
                return /^\d{11}$/.test(v);
            },
            message: props => `${props.value} is not a valid contact number! It must be 11 digits.`,
        },
    },
    address: String,
    adminEmail: String,
});

const Supplier = mongoose.model('Supplier', supplierSchema);
module.exports = Supplier;
