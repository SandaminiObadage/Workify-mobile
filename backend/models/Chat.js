const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema({
  chatRoomId: {
    type: String,
    required: true,
    unique: true
  },
  users: [{
    type: String,
    required: true
  }],
  participants: [{
    userId: String,
    username: String,
    profile: String
  }],
  lastMessage: {
    type: String,
    default: ''
  },
  lastMessageTime: {
    type: Date,
    default: Date.now
  },
  lastMessageType: {
    type: String,
    default: 'text'
  },
  sender: {
    type: String,
    default: ''
  },
  senderProfile: {
    type: String,
    default: ''
  },
  read: {
    type: Boolean,
    default: false
  },
  unreadCount: {
    type: Map,
    of: Number,
    default: {}
  }
}, {
  timestamps: true
});

// Index for faster queries
chatSchema.index({ users: 1 });
chatSchema.index({ lastMessageTime: -1 });

module.exports = mongoose.model('Chat', chatSchema);
