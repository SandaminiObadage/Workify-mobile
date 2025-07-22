const mongoose = require("mongoose");

const skillModel = mongoose.Schema(
    {
        skill: { type: String},
        userId: { type: String },
    }
);

module.exports = mongoose.model("Skill", skillModel);

