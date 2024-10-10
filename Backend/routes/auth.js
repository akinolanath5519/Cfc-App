const express = require('express');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const jwt = require('jsonwebtoken');
const User = require('../models/user');

const router = express.Router();

// Register Admin
router.post('/register-admin', async (req, res) => {
    const { name, email, password } = req.body;

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = new User({ name, email, password: hashedPassword, role: 'admin' });

    try {
        await user.save();
        res.status(201).json({ message: 'Admin registered successfully' });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Register Standard User
router.post('/register-standard', async (req, res) => {
    const { name, email, password, adminEmail } = req.body;

    const admin = await User.findOne({ email: adminEmail, role: 'admin' });
    if (!admin) {
        return res.status(400).json({ message: 'Admin not found' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = new User({ name, email, password: hashedPassword, role: 'standard', adminEmail });

    try {
        await user.save();
        res.status(201).json({ message: 'Standard user registered successfully' });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Login
router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
        return res.status(400).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user._id, role: user.role, adminEmail: user.adminEmail || user.email }, 'secretKey', { expiresIn: '1h' });
    
    res.status(200).json({ token, role: user.role });
});





module.exports = router;
