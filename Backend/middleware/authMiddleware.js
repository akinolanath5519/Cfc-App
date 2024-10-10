const jwt = require('jsonwebtoken');
const User = require('../models/user');

const authMiddleware = (req, res, next) => {
    const token = req.header('Authorization').replace('Bearer ', '');
    try {
        const decoded = jwt.verify(token, 'secretKey');
        req.user = decoded;
        next();
    } catch (error) {
        return res.status(401).json({ message: 'Authentication failed.' });
    }
};

const verifyAdminOrStandard = async (req, res, next) => {
    const user = await User.findById(req.user.id);
    if (user.role === 'admin' || user.adminEmail === req.user.adminEmail) {
        next();
    } else {
        res.status(403).json({ message: 'Unauthorized access.' });
    }
};

module.exports = { authMiddleware, verifyAdminOrStandard };
