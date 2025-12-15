const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const { verifyToken } = require('../middleware/verifyToken');

// All routes require authentication
router.use(verifyToken);

// Chat room routes
router.post('/create', chatController.createChatRoom);
router.get('/rooms', chatController.getChatRooms);
router.get('/exists/:chatRoomId', chatController.chatRoomExists);
router.delete('/:chatRoomId', chatController.deleteChat);

// Message routes
router.post('/message', chatController.sendMessage);
router.get('/messages/:chatRoomId', chatController.getMessages);
router.put('/read', chatController.markAsRead);
router.get('/unread-count', chatController.getUnreadCount);

// Status routes
router.post('/online-status', chatController.setOnlineStatus);
router.get('/online-status', chatController.getOnlineStatus);

// Typing status routes
router.post('/typing', chatController.setTypingStatus);
router.get('/typing/:chatRoomId', chatController.getTypingStatus);

module.exports = router;
