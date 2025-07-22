const mongoose = require("mongoose");

const applicationSchema = mongoose.Schema(
    {
        user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
        job: { type: mongoose.Schema.Types.ObjectId, ref: "Job" },
    },
    { timestamps: true }
);

module.exports = mongoose.model("Application", applicationSchema);