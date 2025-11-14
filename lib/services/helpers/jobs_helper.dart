import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobhubv2_0/models/response/jobs/get_job.dart';
import 'package:jobhubv2_0/models/response/jobs/jobs_response.dart';
import 'package:jobhubv2_0/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobsHelper {
  static var client = http.Client();

  static Future<bool> createJob(String model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // Handle the case where the token is null (e.g., request a new token or logout).
        return false;
      }

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      var url = Uri.parse('${Config.baseUrl}${Config.jobs}');
      var response = await client.post(
        url,
        body: model,
        headers: requestHeaders,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        // Handle different error scenarios here.
        return false;
      }
    } catch (e) {
      // Handle exceptions here (e.g., network issues, unexpected errors).
      return false;
    }
  }

  static Future<bool> updateJob(String jobId, String model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // Handle the case where the token is null (e.g., request a new token or logout).
        return false;
      }

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      var url = Uri.parse('${Config.baseUrl}${Config.jobs}/$jobId');
      var response = await client.put(
        url,
        body: model,
        headers: requestHeaders,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        // Handle different error scenarios here.
        return false;
      }
    } catch (e) {
      // Handle exceptions here (e.g., network issues, unexpected errors).
      return false;
    }
  }

  static Future<List<JobsResponse>> getJobs() async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var url = Uri.parse('${Config.baseUrl}${Config.jobs}');
      print('Making request to: $url'); // Debug print
      
      var response = await client.get(
        url,
        headers: requestHeaders,
      ).timeout(Duration(seconds: 10));

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        var jobsList = jobsResponseFromJson(response.body);
        return jobsList;
      } else {
        throw Exception("Failed to get jobs. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching jobs: $e'); // Debug print
      throw Exception("Failed to get the jobs: $e");
    }
  }

// get job
  static Future<GetJobRes> getJob(String jobId) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var url = Uri.parse('${Config.baseUrl}${Config.jobs}/$jobId');
      var response = await client.get(
        url,
        headers: requestHeaders,
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var job = getJobResFromJson(response.body);
        return job;
      } else {
        throw Exception("Failed to get job. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching job: $e');
      throw Exception("Failed to get the job: $e");
    }
  }

  static Future<JobsResponse> getRecent() async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var url = Uri.parse('${Config.baseUrl}${Config.jobs}');
      var response = await client.get(
        url,
        headers: requestHeaders,
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jobsList = jobsResponseFromJson(response.body);
        if (jobsList.isNotEmpty) {
          var recent = jobsList.first;
          return recent;
        } else {
          throw Exception("No jobs found");
        }
      } else {
        throw Exception("Failed to get recent job. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching recent job: $e');
      throw Exception("Failed to get the recent job: $e");
    }
  }

//SEARCH
  static Future<List<JobsResponse>> searchJobs(String searchQuery) async {
    if (searchQuery.trim().isEmpty) {
      return [];
    }

    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Encode the search query to handle spaces and special characters
      String encodedQuery = Uri.encodeComponent(searchQuery.trim());
      var url = Uri.parse('${Config.baseUrl}${Config.search}/$encodedQuery');
      
      print('Search URL: $url'); // Debug print
      
      var response = await client.get(
        url,
        headers: requestHeaders,
      ).timeout(Duration(seconds: 10));

      print('Search Response status: ${response.statusCode}'); // Debug print
      print('Search Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        var jobsList = jobsResponseFromJson(response.body);
        return jobsList;
      } else {
        print('Search failed with status: ${response.statusCode}');
        throw Exception("Search failed: ${response.statusCode}");
      }
    } catch (e) {
      print('Search error: $e');
      throw Exception("Failed to search jobs: $e");
    }
  }

  // Advanced search function
  static Future<List<JobsResponse>> advancedSearchJobs({
    String? searchTerm,
    String? location,
    String? contract,
    String? period,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> searchData = {};
    
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      searchData['searchTerm'] = searchTerm.trim();
    }
    if (location != null && location.trim().isNotEmpty) {
      searchData['location'] = location.trim();
    }
    if (contract != null && contract.trim().isNotEmpty) {
      searchData['contract'] = contract.trim();
    }
    if (period != null && period.trim().isNotEmpty) {
      searchData['period'] = period.trim();
    }

    var url = Uri.parse('${Config.baseUrl}/api/jobs/search/advanced');
    
    try {
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(searchData),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          var jobsList = jobsResponseFromJson(jsonEncode(responseData['jobs']));
          return jobsList;
        } else {
          throw Exception("Advanced search failed");
        }
      } else {
        throw Exception("Advanced search failed: ${response.statusCode}");
      }
    } catch (e) {
      print('Advanced search error: $e');
      throw Exception("Failed to perform advanced search: $e");
    }
  }
}
