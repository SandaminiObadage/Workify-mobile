import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/services/helpers/chat_helper.dart';

class ChatNotifier extends ChangeNotifier {
  bool _focused = false;
  List<dynamic> _chatRooms = [];
  List<dynamic> _messages = [];
  bool _isLoading = false;
  String _error = '';
  Timer? _pollTimer;
  Timer? _typingPollTimer;
  List<dynamic> _typingUsers = [];

  bool get isFocused => _focused;
  List<dynamic> get chatRooms => _chatRooms;
  List<dynamic> get messages => _messages;
  bool get isLoading => _isLoading;
  String get error => _error;
  List<dynamic> get typingUsers => _typingUsers;

  set isFocused(bool newState) {
    if (_focused != newState) {
      _focused = newState;
      notifyListeners();
    }
  }

  // Set online status
  Future<void> onlineStatus(bool isLoggedIn, ZoomNotifier zoomNotifier) async {
    if (isLoggedIn == true && zoomNotifier.currentIndex == 1) {
      await ChatHelper.setOnlineStatus(true);
      // Start polling for chat updates
      startPolling();
    }
  }

  // Set offline status
  Future<void> offlineStatus(bool isLoggedIn, ZoomNotifier zoomNotifier) async {
    if (isLoggedIn == false && zoomNotifier.currentIndex != 1 ||
        isLoggedIn == true && zoomNotifier.currentIndex != 1) {
      await ChatHelper.setOnlineStatus(false);
      // Stop polling
      stopPolling();
    }
  }

  // Start polling for chat updates (every 3 seconds)
  void startPolling() {
    stopPolling(); // Clear any existing timers
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchChatRooms();
    });
    // Fetch immediately
    fetchChatRooms();
  }

  // Stop polling
  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _typingPollTimer?.cancel();
    _typingPollTimer = null;
  }

  // Fetch all chat rooms
  Future<void> fetchChatRooms() async {
    try {
      final rooms = await ChatHelper.getChatRooms();
      if (rooms != null) {
        _chatRooms = rooms;
        _error = '';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error fetching chats: $e';
      print(_error);
    }
  }

  // Create or get chat room
  Future<Map<String, dynamic>?> createChatRoom({
    required String chatRoomId,
    required List<dynamic> participants,
    required String receiver,
  }) async {
    try {
      final result = await ChatHelper.createChatRoom(
        chatRoomId: chatRoomId,
        participants: participants,
        receiver: receiver,
      );
      if (result != null) {
        await fetchChatRooms(); // Refresh list
      }
      return result;
    } catch (e) {
      _error = 'Error creating chat: $e';
      print(_error);
      return null;
    }
  }

  // Check if chat room exists
  Future<bool> chatRoomExists(String chatRoomId) async {
    try {
      return await ChatHelper.chatRoomExists(chatRoomId);
    } catch (e) {
      print('Error checking chat room: $e');
      return false;
    }
  }

  // Fetch messages for a chat room
  Future<void> fetchMessages(String chatRoomId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final msgs = await ChatHelper.getMessages(chatRoomId);
      if (msgs != null) {
        _messages = msgs;
        _error = '';
      }
    } catch (e) {
      _error = 'Error fetching messages: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Start polling messages for a specific chat room (every 2 seconds)
  void startMessagePolling(String chatRoomId) {
    stopPolling(); // Clear chat list polling
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchMessages(chatRoomId);
    });
    // Fetch immediately
    fetchMessages(chatRoomId);
    
    // Also poll for typing status
    startTypingPolling(chatRoomId);
  }

  // Start polling typing status (every 1 second)
  void startTypingPolling(String chatRoomId) {
    _typingPollTimer?.cancel();
    _typingPollTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchTypingStatus(chatRoomId);
    });
  }

  // Send a message
  Future<bool> sendMessage({
    required String chatRoomId,
    required String receiver,
    required String message,
    required String senderName,
    String? senderProfile,
    String messageType = 'text',
  }) async {
    try {
      final result = await ChatHelper.sendMessage(
        chatRoomId: chatRoomId,
        receiver: receiver,
        message: message,
        senderName: senderName,
        senderProfile: senderProfile,
        messageType: messageType,
      );
      
      if (result != null) {
        // Immediately fetch messages to show the new message
        await fetchMessages(chatRoomId);
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Error sending message: $e';
      print(_error);
      return false;
    }
  }

  // Mark messages as read
  Future<void> markAsRead(String chatRoomId) async {
    try {
      await ChatHelper.markAsRead(chatRoomId);
      await fetchChatRooms(); // Refresh to update read status
    } catch (e) {
      print('Error marking as read: $e');
    }
  }

  // Delete chat
  Future<bool> deleteChat(String chatRoomId) async {
    try {
      final success = await ChatHelper.deleteChat(chatRoomId);
      if (success) {
        await fetchChatRooms(); // Refresh list
      }
      return success;
    } catch (e) {
      _error = 'Error deleting chat: $e';
      print(_error);
      return false;
    }
  }

  // Set typing status
  Future<void> setTypingStatus(String chatRoomId, bool isTyping) async {
    try {
      await ChatHelper.setTypingStatus(chatRoomId, isTyping);
    } catch (e) {
      print('Error setting typing status: $e');
    }
  }

  // Fetch typing status
  Future<void> fetchTypingStatus(String chatRoomId) async {
    try {
      final users = await ChatHelper.getTypingStatus(chatRoomId);
      if (users != null) {
        _typingUsers = users;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching typing status: $e');
    }
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    try {
      return await ChatHelper.getUnreadCount();
    } catch (e) {
      print('Error fetching unread count: $e');
      return 0;
    }
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
