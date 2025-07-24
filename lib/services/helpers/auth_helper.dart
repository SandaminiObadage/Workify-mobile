import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jobhubv2_0/models/response/auth/skills.dart';
import 'package:jobhubv2_0/models/response/auth/login_res_model.dart';
import 'package:jobhubv2_0/models/response/auth/profile_model.dart';
import 'package:jobhubv2_0/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static var client = http.Client();

  static Future<bool> login(model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiUrl, Config.loginUrl);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: model,
    );

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = loginResponseModelFromJson(response.body).userToken;
      String userId = loginResponseModelFromJson(response.body).id;
      String profile = loginResponseModelFromJson(response.body).profile;
      String uid = loginResponseModelFromJson(response.body).uid;
      String username = loginResponseModelFromJson(response.body).username;

      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setString('profile', profile);
      await prefs.setString('uid', uid);
      await prefs.setString('username', username);
      await prefs.setBool('loggedIn', true);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> signup(String model) async {
    try {
      Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

      var url = Uri.http(Config.apiUrl, Config.signupUrl);
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: model,
      );
        print("--my response is ${response.body}  status code is ${response.statusCode}");
      if (response.statusCode == 201) {
        return true;
      } else {
        // Handle different error scenarios here, log errors, etc.
        return false;
      }
    } catch (e) {
      // Handle exceptions here (e.g., network issues, unexpected errors).
      return false;
    }
  }

  static Future<bool> updateProfile(model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // Handle the case where the token is null (e.g., request a new token or logout).
        print('No authentication token found');
        return false;
      }

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.http(Config.apiUrl, Config.profileUrl);
      var response = await client.put(
        url,
        headers: requestHeaders,
        body: jsonEncode(model),
      );

      print('Profile update response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle different error scenarios here, log errors, etc.
        print('Profile update failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle exceptions here (e.g., network issues, unexpected errors).
      print('Exception during profile update: $e');
      return false;
    }
  }

  static Future<ProfileRes> getProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("No authentication token found.");
    }

    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    final Uri url = Uri.http(Config.apiUrl, Config.profileUrl);

    try {
      final response = await http.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        return profileResFromJson(response.body);
      } else {
        throw Exception(
            "Failed to get the profile. Status code: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Failed to get the profile: $error");
    }
  }

  static Future<List<Skills>> getSkills() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("No authentication token found.");
    }

    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    final Uri url = Uri.http(Config.apiUrl, Config.skills);
  

    try {
      final response = await http.get(url, headers: requestHeaders);
      
      if (response.statusCode == 200) {
        return skillsFromJson(response.body);
      } else {
        throw Exception(
            "Failed to get the skills. Status code: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Failed to get the skills: $error");
    }
  }


 static Future<bool> addSkill(String model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
       return  false;
    }

    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    final Uri url = Uri.http(Config.apiUrl, Config.skills);

    try {
      final response = await http.post(url,body: model, headers: requestHeaders);
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return  false;
    }
  }


 static Future<bool> deleteSkill(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
       return  false;
    }

    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    final Uri url = Uri.http(Config.apiUrl, "${Config.skills}/$id");

    try {
      final response = await http.delete(url, headers: requestHeaders);
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return  false;
    }
  }



}
