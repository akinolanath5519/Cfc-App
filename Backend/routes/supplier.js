const express = require('express');
const Supplier = require('../models/supplier');
const { authMiddleware, verifyAdminOrStandard } = require('../middleware/authMiddleware');

const router = express.Router();

// Create a Supplier
router.post('/supplier', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const { name, contact, address } = req.body;

    const supplier = new Supplier({
        name,
        contact,
        address,
        adminEmail: req.user.adminEmail,
    });

    try {
        await supplier.save();
        res.status(201).json({ message: 'Supplier created successfully' });
    } catch (error) {
        if (error.name === 'ValidationError') {
            return res.status(400).json({ error: error.message });
        }
        res.status(500).json({ error: 'An unexpected error occurred.', details: error.message });
    }
});

// Get All Suppliers
router.get('/supplier', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const suppliers = await Supplier.find({ adminEmail: req.user.adminEmail });
    res.status(200).json(suppliers);
});

// Get a Single Supplier by ID
router.get('/supplier/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const supplier = await Supplier.findOne({ _id: req.params.id, adminEmail: req.user.adminEmail });
    if (!supplier) {
        return res.status(404).json({ message: 'Supplier not found' });
    }
    res.status(200).json(supplier);
});

// Update a Supplier by ID
router.put('/supplier/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const { name, contact, address } = req.body;

    try {
        const supplier = await Supplier.findOneAndUpdate(
            { _id: req.params.id, adminEmail: req.user.adminEmail },
            { name, contact, address },
            { new: true }
        );

        if (!supplier) {
            return res.status(404).json({ message: 'Supplier not found or unauthorized' });
        }

        res.status(200).json({ message: 'Supplier updated successfully', supplier });
    } catch (error) {
        res.status(500).json({ error: 'An unexpected error occurred.', details: error.message });
    }
});

// Delete a Supplier by ID
router.delete('/supplier/:id', authMiddleware, verifyAdminOrStandard, async (req, res) => {
    const supplier = await Supplier.findOneAndDelete({ _id: req.params.id, adminEmail: req.user.adminEmail });

    if (!supplier) {
        return res.status(404).json({ message: 'Supplier not found or unauthorized' });
    }

    res.status(200).json({ message: 'Supplier deleted successfully' });
});

module.exports = router;
