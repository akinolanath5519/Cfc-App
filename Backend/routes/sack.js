const express = require('express');
const Sack = require('../models/sack'); // Import the Sack model
const { authMiddleware, verifyAdminOrStandard } = require('../middleware/authMiddleware'); // Import the middleware for authentication

const router = express.Router();

// Create a Sack Record
router.post('/sack', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const { supplierName, date, bagsCollected, bagsReturned } = req.body;

    const bagsRemaining = bagsCollected - bagsReturned; // Calculate bagsRemaining

    const sack = new Sack({
        supplierName,
        date,
        bagsCollected,
        bagsReturned,
        bagsRemaining,
        adminEmail: req.user.adminEmail, // Link sack record to the admin
    });

    try {
        await sack.save();
        res.status(201).json({ message: 'Sack record created successfully' });
    } catch (error) {
        if (error.name === 'ValidationError') {
            return res.status(400).json({ error: error.message });
        }
        res.status(500).json({ error: 'An unexpected error occurred.', details: error.message });
    }
});

// Get All Sack Records
router.get('/sack', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const sacks = await Sack.find({ adminEmail: req.user.adminEmail });
    res.status(200).json(sacks);
});

// Get a Single Sack Record by ID
router.get('/sack/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const sack = await Sack.findOne({ _id: req.params.id, adminEmail: req.user.adminEmail });
    if (!sack) {
        return res.status(404).json({ message: 'Sack record not found' });
    }
    res.status(200).json(sack);
});

// Update a Sack Record by ID
router.put('/sack/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const { supplierName, date, bagsCollected, bagsReturned } = req.body;
    const bagsRemaining = bagsCollected - bagsReturned;

    try {
        const sack = await Sack.findOneAndUpdate(
            { _id: req.params.id, adminEmail: req.user.adminEmail },
            { supplierName, date, bagsCollected, bagsReturned, bagsRemaining },
            { new: true }
        );

        if (!sack) {
            return res.status(404).json({ message: 'Sack record not found or unauthorized' });
        }

        res.status(200).json({ message: 'Sack record updated successfully', sack });
    } catch (error) {
        res.status(500).json({ error: 'An unexpected error occurred.', details: error.message });
    }
});

// Delete a Sack Record by ID
router.delete('/sack/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const sack = await Sack.findOneAndDelete({ _id: req.params.id, adminEmail: req.user.adminEmail });

    if (!sack) {
        return res.status(404).json({ message: 'Sack record not found or unauthorized' });
    }

    res.status(200).json({ message: 'Sack record deleted successfully' });
});

module.exports = router;
