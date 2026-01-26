import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class AuthHelper {
  static const String baseUrl = '${Config.baseUrl}/api/users';

  // Check if current user is an admin
  static Future<bool> isAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      print('🔑 Token exists: ${token != null}');
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Profile API response status: ${response.statusCode}');
      print('📡 Profile API response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isAdmin = data['isAdmin'] ?? false;
        print('👑 isAdmin value from API: $isAdmin');
        return isAdmin;
      }
      return false;
    } catch (e) {
      print('❌ Error checking admin status: $e');
      return false;
    }
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Store admin status locally for quick access
  static Future<void> cacheAdminStatus(bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdmin', isAdmin);
  }

  // Get cached admin status
  static Future<bool> getCachedAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAdmin') ?? false;
  }
}
