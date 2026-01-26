import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_models.dart';
import 'config.dart';

class AdminService {
  static const String baseUrl = '${Config.baseUrl}/api/admin';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Dashboard Stats
  Future<AdminStats> getDashboardStats() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/stats'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return AdminStats.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load stats: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching stats: $e');
    }
  }

  // User Management
  Future<Map<String, dynamic>> getAllUsers({int page = 1, String search = ''}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users?page=$page&limit=20&search=$search'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final users = (data['users'] as List)
            .map((user) => AdminUser.fromJson(user))
            .toList();
        
        return {
          'users': users,
          'totalPages': data['totalPages'],
          'currentPage': data['currentPage'],
          'totalUsers': data['totalUsers'],
        };
      } else {
        throw Exception('Failed to load users: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<bool> updateUserStatus(String userId, bool isAgent) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId/status'),
        headers: headers,
        body: json.encode({'isAgent': isAgent}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating user status: $e');
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  // Job Management
  Future<Map<String, dynamic>> getAllJobs({
    int page = 1,
    String search = '',
    String status = 'all',
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/jobs?page=$page&limit=20&search=$search&status=$status'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jobs = (data['jobs'] as List)
            .map((job) => AdminJob.fromJson(job))
            .toList();
        
        return {
          'jobs': jobs,
          'totalPages': data['totalPages'],
          'currentPage': data['currentPage'],
          'totalJobs': data['totalJobs'],
        };
      } else {
        throw Exception('Failed to load jobs: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching jobs: $e');
    }
  }

  Future<bool> updateJobStatus(String jobId, bool hiring) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/jobs/$jobId/status'),
        headers: headers,
        body: json.encode({'hiring': hiring}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating job status: $e');
    }
  }

  Future<bool> deleteJob(String jobId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/jobs/$jobId'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting job: $e');
    }
  }

  // Analytics
  Future<List<ChartData>> getUserGrowthStats() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/analytics/user-growth'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => ChartData.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load user growth stats');
      }
    } catch (e) {
      throw Exception('Error fetching user growth stats: $e');
    }
  }

  Future<List<ChartData>> getJobPostingStats() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/analytics/job-posting'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => ChartData.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load job posting stats');
      }
    } catch (e) {
      throw Exception('Error fetching job posting stats: $e');
    }
  }

  Future<List<ChartData>> getApplicationStats() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/analytics/applications'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => ChartData.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load application stats');
      }
    } catch (e) {
      throw Exception('Error fetching application stats: $e');
    }
  }

  Future<Map<String, dynamic>> getAllAgents({int page = 1}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/agents?page=$page&limit=20'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final agents = (data['agents'] as List)
            .map((agent) => AdminUser.fromJson(agent))
            .toList();
        
        return {
          'agents': agents,
          'totalPages': data['totalPages'],
          'currentPage': data['currentPage'],
          'totalAgents': data['totalAgents'],
        };
      } else {
        throw Exception('Failed to load agents: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching agents: $e');
    }
  }
}
