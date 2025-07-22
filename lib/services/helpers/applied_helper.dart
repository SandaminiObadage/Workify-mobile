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

    var url = Uri.http(Config.apiUrl, Config.applied);
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // DELETE BOOKMARKS
  static Future<List<Applied>> getApplied() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var url = Uri.http(Config.apiUrl, Config.applied);
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
}
