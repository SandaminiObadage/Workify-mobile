import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobhubv2_0/models/request/applied/applied.dart';
import 'package:jobhubv2_0/models/response/applied/applied.dart';
import 'package:jobhubv2_0/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppliedHelper {
  static var client = http.Client();

// ADD BOOKMARKS
  static Future<bool> applyJob(AppliedPost model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.parse('${Config.baseUrl}${Config.applied}');
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // GET APPLIED JOBS
  static Future<List<Applied>> getApplied() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.parse('${Config.baseUrl}${Config.applied}');
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var applied = appliedFromJson(response.body);

      return applied;
    } else {
      throw Exception('Failed to applied jobs');
    }
  }

  // CHECK IF USER HAS ALREADY APPLIED TO A JOB
  static Future<bool> hasUserApplied(String jobId) async {
    try {
      List<Applied> appliedJobs = await getApplied();
      
      // Check if job is in the applied list
      bool hasApplied = appliedJobs.any((application) => application.job.id == jobId);
      
      return hasApplied;
    } catch (e) {
      print('Error checking if user applied: $e');
      return false;
    }
  }

  // GET APPLICANTS FOR A SPECIFIC JOB
  static Future<List<dynamic>> getJobApplicants(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.parse('${Config.baseUrl}${Config.applied}/job/$jobId');
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get job applicants');
    }
  }
}
