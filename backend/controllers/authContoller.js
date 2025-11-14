const User = require("../models/User");
const CryptoJS = require("crypto-js");
const jwt = require("jsonwebtoken");
const admin = require('firebase-admin')


module.exports = {
    createUser: async (req, res) => {
        const user = req.body;

        try {
            // Temporarily bypass Firebase for testing
            const newUser = new User({
                username: req.body.username,
                email: req.body.email,
                uid: "temp_" + Date.now(), // temporary UID
                password: CryptoJS.AES.encrypt(req.body.password, process.env.SECRET).toString(),
                profile: "https://ui-avatars.com/api/?name=" + encodeURIComponent(req.body.username) + "&background=0D8ABC&color=fff"
            });

            await newUser.save();
            res.status(201).json({ status: true })
            
        } catch (error) {
            console.log("Registration error:", error);
            res.status(500).json({ error: 'An error occurred while creating the user.' });
        }
    },

    loginUser: async (req, res) => {
        try {
            const user = await User.findOne({ email: req.body.email }, { __v: 0, createdAt: 0, updatedAt: 0, skills: 0, email: 0});
            if (!user) {
                return res.status(401).json("Wrong Login Details");
            }

            const decrytedpass = CryptoJS.AES.decrypt(user.password, process.env.SECRET);
            const depassword = decrytedpass.toString(CryptoJS.enc.Utf8);

            if (depassword !== req.body.password) {
                return res.status(401).json("Wrong Login Details");
            }

            const userToken = jwt.sign({
                id: user._id, isAdmin: user.isAdmin, isAgent: user.isAgent
            }, process.env.JWT_SEC,
                { expiresIn: "21d" });


            const { password, isAdmin, ...others } = user._doc;

            res.status(200).json({ ...others, userToken });

        } catch (error) {
            console.log("Login error:", error);
            res.status(500).json({ error: 'An error occurred during login.' });
        }
    },

    getAllUsers: async (req, res) => {
        try {
            const users = await User.find({}, { password: 0, __v: 0 }); // Exclude password and version
            res.status(200).json(users);
        } catch (error) {
            console.log("Get users error:", error);
            res.status(500).json({ error: 'An error occurred while fetching users.' });
        }
    }
}