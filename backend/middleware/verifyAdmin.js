const User = require("../models/User");

const verifyAdmin = async (req, res, next) => {
    try {
        // Check if user is authenticated (assuming verifyToken middleware runs first)
        if (!req.user || !req.user.id) {
            return res.status(401).json({ message: "Unauthorized - No user found" });
        }

        // Check if user is admin
        const user = await User.findById(req.user.id);
        
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        if (!user.isAdmin) {
            return res.status(403).json({ message: "Forbidden - Admin access required" });
        }

        // User is admin, proceed
        next();
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = verifyAdmin;
