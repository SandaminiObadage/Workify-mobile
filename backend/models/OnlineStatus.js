const mongoose = require('mongoose');

const onlineStatusSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
    unique: true
  },
  isOnline: {
    type: Boolean,
    default: false
  },
  lastSeen: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Index for faster queries
onlineStatusSchema.index({ userId: 1 });
onlineStatusSchema.index({ isOnline: 1 });

module.exports = mongoose.model('OnlineStatus', onlineStatusSchema);
