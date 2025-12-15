import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobhubv2_0/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHelper {
  static const String baseUrl = '${Config.baseUrl}/api/chat';

  // Get auth token
  static Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Create or get chat room
  static Future<Map<String, dynamic>?> createChatRoom({
    required String chatRoomId,
    required List<dynamic> participants,
    required String receiver,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'chatRoomId': chatRoomId,
          'participants': participants,
          'receiver': receiver,
        }),
      );

      print('Create chat room response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error creating chat room: $e');
      return null;
    }
  }

  // Get all chat rooms for current user
  static Future<List<dynamic>?> getChatRooms() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/rooms'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['chats'] as List<dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching chat rooms: $e');
      return null;
    }
  }

  // Check if chat room exists
  static Future<bool> chatRoomExists(String chatRoomId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/exists/$chatRoomId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exists'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking chat room: $e');
      return false;
    }
  }

  // Send a message
  static Future<Map<String, dynamic>?> sendMessage({
    required String chatRoomId,
    required String receiver,
    required String message,
    required String senderName,
    String? senderProfile,
    String messageType = 'text',
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.post(
        Uri.parse('$baseUrl/message'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'chatRoomId': chatRoomId,
          'receiver': receiver,
          'message': message,
          'senderName': senderName,
          'senderProfile': senderProfile ?? '',
          'messageType': messageType,
        }),
      );

      print('Send message response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

  // Get messages for a chat room
  static Future<List<dynamic>?> getMessages(String chatRoomId, {int limit = 100, int skip = 0}) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/messages/$chatRoomId?limit=$limit&skip=$skip'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['messages'] as List<dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching messages: $e');
      return null;
    }
  }

  // Mark messages as read
  static Future<bool> markAsRead(String chatRoomId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrl/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'chatRoomId': chatRoomId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking messages as read: $e');
      return false;
    }
  }

  // Delete a chat
  static Future<bool> deleteChat(String chatRoomId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('$baseUrl/$chatRoomId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting chat: $e');
      return false;
    }
  }

  // Set online status
  static Future<bool> setOnlineStatus(bool isOnline) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/online-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'isOnline': isOnline,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error setting online status: $e');
      return false;
    }
  }

  // Get online status for users
  static Future<List<dynamic>?> getOnlineStatus(List<String> userIds) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/online-status?userIds=${userIds.join(',')}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['statuses'] as List<dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching online status: $e');
      return null;
    }
  }

  // Set typing status
  static Future<bool> setTypingStatus(String chatRoomId, bool isTyping) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/typing'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'chatRoomId': chatRoomId,
          'isTyping': isTyping,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error setting typing status: $e');
      return false;
    }
  }

  // Get typing status for a chat room
  static Future<List<dynamic>?> getTypingStatus(String chatRoomId) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/typing/$chatRoomId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['typingUsers'] as List<dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching typing status: $e');
      return null;
    }
  }

  // Get unread count
  static Future<int> getUnreadCount() async {
    try {
      final token = await _getToken();
      if (token == null) return 0;

      final response = await http.get(
        Uri.parse('$baseUrl/unread-count'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['unreadCount'] ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error fetching unread count: $e');
      return 0;
    }
  }
}
