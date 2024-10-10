const express = require('express');
const Commodity = require('../models/commodity'); // Import the Commodity model
const { authMiddleware, verifyAdminOrStandard } = require('../middleware/authMiddleware'); // Import the middleware for authentication

const router = express.Router();

// Create a Commodity
router.post('/commodity', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const { name, rate } = req.body;

    const commodity = new Commodity({
        name,
        rate,
        adminEmail: req.user.adminEmail, // Link commodity to the admin
    });

    try {
        await commodity.save();
        res.status(201).json({ message: 'Commodity created successfully' });
    } catch (error) {
        if (error.name === 'ValidationError') {
            return res.status(400).json({ error: error.message });
        }
        res.status(500).json({ error: 'An unexpected error occurred.', details: error.message });
    }
});

// Get All Commodities
router.get('/commodity', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const commodities = await Commodity.find({ adminEmail: req.user.adminEmail });
    res.status(200).json(commodities);
});

// Get a Single Commodity by ID
router.get('/commodity/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const commodity = await Commodity.findOne({ _id: req.params.id, adminEmail: req.user.adminEmail });
    if (!commodity) {
        return res.status(404).json({ message: 'Commodity not found' });
    }
    res.status(200).json(commodity);
});

// Update a Commodity by ID
router.put('/commodity/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const { name, rate } = req.body;

    try {
        const commodity = await Commodity.findOneAndUpdate(
            { _id: req.params.id, adminEmail: req.user.adminEmail },
            { name, rate },
            { new: true }
        );

        if (!commodity) {
            return res.status(404).json({ message: 'Commodity not found or unauthorized' });
        }

        res.status(200).json({ message: 'Commodity updated successfully', commodity });
    } catch (error) {
        res.status(500).json({ error: 'An unexpected error occurred.', details: error.message });
    }
});

// Delete a Commodity by ID
router.delete('/commodity/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const commodity = await Commodity.findOneAndDelete({ _id: req.params.id, adminEmail: req.user.adminEmail });

    if (!commodity) {
        return res.status(404).json({ message: 'Commodity not found or unauthorized' });
    }

    res.status(200).json({ message: 'Commodity deleted successfully' });
});

module.exports = router;
