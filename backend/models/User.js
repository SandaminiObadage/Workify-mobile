const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema(
    {
        username: { type: String, required: true, unique: true },
        email: { type: String, required: true, unique: true },
        uid: { type: String, required: true, unique: true},
        password: { type: String, required: true },
        location: { type: String, required: false },
        phone: { type: String, required: false },
        updated: {
            type: Boolean,
            default: false
        },
        isAdmin: {
            type: Boolean,
            default: false
        },
        isAgent: {
            type: Boolean,
            default: false
        },
        skills: {
            type: Boolean,
            required: false,
            default: false,
        },
        profile: {
            type: String,
            require: true,
            default: "https://d326fntlu7tb1e.cloudfront.net/uploads/bdec9d7d-0544-4fc4-823d-3b898f6dbbbf-vinci_03.jpeg"
        },

    }, { timestamps: true }
);
module.exports = mongoose.model("User", UserSchema)