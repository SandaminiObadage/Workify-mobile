const Chat = require('../models/Chat');
const Message = require('../models/Message');
const OnlineStatus = require('../models/OnlineStatus');
const TypingStatus = require('../models/TypingStatus');

// Create or get existing chat room
exports.createChatRoom = async (req, res) => {
  try {
    const { chatRoomId, participants, receiver } = req.body;
    const userId = req.user.id;

    if (!chatRoomId || !participants || !receiver) {
      return res.status(400).json({ status: false, message: 'Missing required fields' });
    }

    // Check if chat already exists
    let chat = await Chat.findOne({ chatRoomId });

    if (chat) {
      return res.status(200).json({ 
        status: true, 
        message: 'Chat room already exists',
        chat 
      });
    }

    // Create new chat room
    chat = new Chat({
      chatRoomId,
      users: [userId, receiver],
      participants
    });

    await chat.save();

    res.status(201).json({ 
      status: true, 
      message: 'Chat room created successfully',
      chat 
    });
  } catch (error) {
    console.error('Error creating chat room:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Get all chat rooms for a user
exports.getChatRooms = async (req, res) => {
  try {
    const userId = req.user.id;

    const chats = await Chat.find({ 
      users: userId 
    }).sort({ lastMessageTime: -1 });

    res.status(200).json({ 
      status: true, 
      chats 
    });
  } catch (error) {
    console.error('Error fetching chat rooms:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Check if chat room exists
exports.chatRoomExists = async (req, res) => {
  try {
    const { chatRoomId } = req.params;

    const chat = await Chat.findOne({ chatRoomId });

    res.status(200).json({ 
      status: true, 
      exists: !!chat,
      chat 
    });
  } catch (error) {
    console.error('Error checking chat room:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Send a message
exports.sendMessage = async (req, res) => {
  try {
    const { chatRoomId, receiver, message, messageType, senderName, senderProfile } = req.body;
    const userId = req.user.id;

    if (!chatRoomId || !receiver || !message) {
      return res.status(400).json({ status: false, message: 'Missing required fields' });
    }

    // Create message
    const newMessage = new Message({
      chatRoomId,
      sender: userId,
      senderName,
      senderProfile: senderProfile || '',
      receiver,
      message,
      messageType: messageType || 'text',
      time: new Date()
    });

    await newMessage.save();

    // Update chat room with last message
    await Chat.findOneAndUpdate(
      { chatRoomId },
      {
        lastMessage: message,
        lastMessageTime: new Date(),
        lastMessageType: messageType || 'text',
        sender: userId,
        senderProfile: senderProfile || '',
        read: false,
        $inc: { [`unreadCount.${receiver}`]: 1 }
      },
      { upsert: true, new: true }
    );

    // Remove typing status
    await TypingStatus.findOneAndDelete({ chatRoomId, userId });

    res.status(201).json({ 
      status: true, 
      message: 'Message sent successfully',
      data: newMessage 
    });
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Get messages for a chat room
exports.getMessages = async (req, res) => {
  try {
    const { chatRoomId } = req.params;
    const { limit = 100, skip = 0 } = req.query;

    const messages = await Message.find({ chatRoomId })
      .sort({ time: 1 })
      .skip(parseInt(skip))
      .limit(parseInt(limit));

    res.status(200).json({ 
      status: true, 
      messages 
    });
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Mark messages as read
exports.markAsRead = async (req, res) => {
  try {
    const { chatRoomId } = req.body;
    const userId = req.user.id;

    if (!chatRoomId) {
      return res.status(400).json({ status: false, message: 'Chat room ID is required' });
    }

    // Update all unread messages from the other user
    await Message.updateMany(
      { 
        chatRoomId, 
        receiver: userId,
        read: false 
      },
      { 
        read: true 
      }
    );

    // Update chat room read status and reset unread count
    await Chat.findOneAndUpdate(
      { chatRoomId },
      { 
        read: true,
        [`unreadCount.${userId}`]: 0
      }
    );

    res.status(200).json({ 
      status: true, 
      message: 'Messages marked as read' 
    });
  } catch (error) {
    console.error('Error marking messages as read:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Delete a chat room
exports.deleteChat = async (req, res) => {
  try {
    const { chatRoomId } = req.params;
    const userId = req.user.id;

    // Verify user is part of the chat
    const chat = await Chat.findOne({ chatRoomId, users: userId });

    if (!chat) {
      return res.status(404).json({ status: false, message: 'Chat not found' });
    }

    // Delete all messages
    await Message.deleteMany({ chatRoomId });

    // Delete chat room
    await Chat.deleteOne({ chatRoomId });

    res.status(200).json({ 
      status: true, 
      message: 'Chat deleted successfully' 
    });
  } catch (error) {
    console.error('Error deleting chat:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Set online status
exports.setOnlineStatus = async (req, res) => {
  try {
    const userId = req.user.id;
    const { isOnline } = req.body;

    await OnlineStatus.findOneAndUpdate(
      { userId },
      { 
        isOnline: isOnline !== undefined ? isOnline : true,
        lastSeen: new Date()
      },
      { upsert: true, new: true }
    );

    res.status(200).json({ 
      status: true, 
      message: 'Online status updated' 
    });
  } catch (error) {
    console.error('Error updating online status:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Get online status
exports.getOnlineStatus = async (req, res) => {
  try {
    const { userIds } = req.query;

    if (!userIds) {
      return res.status(400).json({ status: false, message: 'User IDs required' });
    }

    const ids = Array.isArray(userIds) ? userIds : userIds.split(',');

    const statuses = await OnlineStatus.find({ 
      userId: { $in: ids } 
    });

    res.status(200).json({ 
      status: true, 
      statuses 
    });
  } catch (error) {
    console.error('Error fetching online status:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Set typing status
exports.setTypingStatus = async (req, res) => {
  try {
    const userId = req.user.id;
    const { chatRoomId, isTyping } = req.body;

    if (!chatRoomId) {
      return res.status(400).json({ status: false, message: 'Chat room ID required' });
    }

    if (isTyping) {
      await TypingStatus.findOneAndUpdate(
        { chatRoomId, userId },
        { 
          isTyping: true,
          updatedAt: new Date()
        },
        { upsert: true, new: true }
      );
    } else {
      await TypingStatus.findOneAndDelete({ chatRoomId, userId });
    }

    res.status(200).json({ 
      status: true, 
      message: 'Typing status updated' 
    });
  } catch (error) {
    console.error('Error updating typing status:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Get typing status
exports.getTypingStatus = async (req, res) => {
  try {
    const { chatRoomId } = req.params;
    const userId = req.user.id;

    // Get typing status for other users in this chat room
    const typingUsers = await TypingStatus.find({ 
      chatRoomId,
      userId: { $ne: userId },
      isTyping: true
    });

    res.status(200).json({ 
      status: true, 
      typingUsers 
    });
  } catch (error) {
    console.error('Error fetching typing status:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};

// Get unread count
exports.getUnreadCount = async (req, res) => {
  try {
    const userId = req.user.id;

    const chats = await Chat.find({ 
      users: userId 
    });

    let totalUnread = 0;
    chats.forEach(chat => {
      const unreadCount = chat.unreadCount?.get(userId) || 0;
      totalUnread += unreadCount;
    });

    res.status(200).json({ 
      status: true, 
      unreadCount: totalUnread 
    });
  } catch (error) {
    console.error('Error fetching unread count:', error);
    res.status(500).json({ status: false, message: error.message });
  }
};
