import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobhubv2_0/models/response/jobs/jobs_response.dart';
import 'package:jobhubv2_0/services/config.dart';

class MatchingHelper {
  static var client = http.Client();

  /// Get recommended jobs for a user based on matching algorithm
  static Future<Map<String, dynamic>> getRecommendedJobs(
    String userId, {
    int limit = 10,
  }) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var url = Uri.parse(
        '${Config.baseUrl}/api/matching/jobs/$userId?limit=$limit',
      );
      
      print('Fetching recommended jobs from: $url');
      
      var response = await client.get(
        url,
        headers: requestHeaders,
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final jobsList = (responseData['jobs'] as List?)
            ?.map((job) => JobsResponse.fromJson(job))
            .toList() ?? [];
        
        // Extract match scores from the API response
        final scores = (responseData['jobs'] as List?)
            ?.map((job) => (job['matchScore'] as num?)?.toDouble() ?? 50.0)
            .toList() ?? [];

        return {
          'success': true,
          'jobs': jobsList,
          'scores': scores,
          'message': responseData['message'] ?? 'Jobs fetched successfully',
        };
      } else {
        return {
          'success': false,
          'jobs': [],
          'scores': [],
          'message': 'Failed to fetch recommended jobs: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error fetching recommended jobs: $e');
      return {
        'success': false,
        'jobs': [],
        'scores': [],
        'message': 'Error: $e',
      };
    }
  }

  /// Get match score between specific user and job
  static Future<Map<String, dynamic>> getMatchScore(
    String userId,
    String jobId,
  ) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var url = Uri.parse(
        '${Config.baseUrl}/api/matching/score/$userId/$jobId',
      );
      
      var response = await client.get(
        url,
        headers: requestHeaders,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Failed to fetch match score',
        };
      }
    } catch (e) {
      print('Error fetching match score: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Error: $e',
      };
    }
  }

  /// Get matching summary for a user
  static Future<Map<String, dynamic>> getUserMatchingSummary(
    String userId,
  ) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var url = Uri.parse(
        '${Config.baseUrl}/api/matching/summary/$userId',
      );
      
      var response = await client.get(
        url,
        headers: requestHeaders,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'data': null,
        };
      }
    } catch (e) {
      print('Error fetching matching summary: $e');
      return {
        'success': false,
        'data': null,
      };
    }
  }
}
