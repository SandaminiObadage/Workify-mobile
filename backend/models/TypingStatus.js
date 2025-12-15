const mongoose = require('mongoose');

const typingStatusSchema = new mongoose.Schema({
  chatRoomId: {
    type: String,
    required: true
  },
  userId: {
    type: String,
    required: true
  },
  isTyping: {
    type: Boolean,
    default: true
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Compound index for faster queries
typingStatusSchema.index({ chatRoomId: 1, userId: 1 }, { unique: true });

// Auto-delete typing status after 10 seconds of inactivity
typingStatusSchema.index({ updatedAt: 1 }, { expireAfterSeconds: 10 });

module.exports = mongoose.model('TypingStatus', typingStatusSchema);
