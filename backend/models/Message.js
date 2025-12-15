const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  chatRoomId: {
    type: String,
    required: true
  },
  sender: {
    type: String,
    required: true
  },
  senderName: {
    type: String,
    required: true
  },
  senderProfile: {
    type: String,
    default: ''
  },
  receiver: {
    type: String,
    required: true
  },
  message: {
    type: String,
    required: true
  },
  messageType: {
    type: String,
    default: 'text',
    enum: ['text', 'image', 'file']
  },
  time: {
    type: Date,
    default: Date.now
  },
  read: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

// Index for faster queries
messageSchema.index({ chatRoomId: 1, time: 1 });
messageSchema.index({ sender: 1 });
messageSchema.index({ receiver: 1 });

module.exports = mongoose.model('Message', messageSchema);
