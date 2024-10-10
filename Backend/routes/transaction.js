const express = require('express');
const Transaction = require('../models/transaction'); // Import the Transaction model
const { authMiddleware, verifyAdminOrStandard } = require('../middleware/authMiddleware'); // Import the middleware for authentication

const router = express.Router();

// Create a Transaction Record
router.post('/transaction', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const { weight, unit, price, commodityName, supplierName, transactionDate } = req.body;

    const transaction = new Transaction({
        weight,
        unit,
        price,
        commodityName,
        supplierName,
        transactionDate, // Include the transactionDate
        adminEmail: req.user.adminEmail, // Link transaction record to the admin
    });

    try {
        await transaction.save();
        res.status(201).json({ message: 'Transaction record created successfully' });
    } catch (error) {
        if (error.name === 'ValidationError') {
            return res.status(400).json({ error: error.message });
        }
        res.status(500).json({ error: 'An unexpected error occurred.', details: error.message });
    }
});

// Get All Transaction Records
router.get('/transaction', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const transactions = await Transaction.find({ adminEmail: req.user.adminEmail });
    res.status(200).json(transactions);
});

// Get a Single Transaction Record by ID
router.get('/transaction/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const transaction = await Transaction.findOne({ _id: req.params.id, adminEmail: req.user.adminEmail });
    if (!transaction) {
        return res.status(404).json({ message: 'Transaction record not found' });
    }
    res.status(200).json(transaction);
});

// Update a Transaction Record by ID
router.put('/transaction/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const { weight, unit, price, commodityName, supplierName, transactionDate } = req.body;

    try {
        const transaction = await Transaction.findOneAndUpdate(
            { _id: req.params.id, adminEmail: req.user.adminEmail },
            { weight, unit, price, commodityName, supplierName, transactionDate }, // Include transactionDate
            { new: true }
        );

        if (!transaction) {
            return res.status(404).json({ message: 'Transaction record not found or unauthorized' });
        }

        res.status(200).json({ message: 'Transaction record updated successfully', transaction });
    } catch (error) {
        res.status(500).json({ error: 'An unexpected error occurred.', details: error.message });
    }
});

// Delete a Transaction Record by ID
router.delete('/transaction/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const transaction = await Transaction.findOneAndDelete({ _id: req.params.id, adminEmail: req.user.adminEmail });

    if (!transaction) {
        return res.status(404).json({ message: 'Transaction record not found or unauthorized' });
    }

    res.status(200).json({ message: 'Transaction record deleted successfully' });
});

module.exports = router;
