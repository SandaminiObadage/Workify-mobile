import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jobhubv2_0/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html show Blob, Url, AnchorElement;

class ResumeHelper {
  // Pick and upload resume directly to backend
  static Future<String?> pickAndUploadResume() async {
    try {
      // Pick PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final fileName = result.files.single.name;
        final fileBytes = result.files.single.bytes;
        
        if (fileBytes != null) {
          return await uploadResumeToBackend(fileBytes, fileName);
        }
      }
      return null;
    } catch (e) {
      print('Error picking resume: $e');
      return null;
    }
  }

  // Upload resume directly to backend
  static Future<String?> uploadResumeToBackend(Uint8List fileBytes, String fileName) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('No authentication token found');
        return null;
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.baseUrl}/api/users/upload-resume'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Add file
      request.files.add(
        http.MultipartFile.fromBytes(
          'resume',
          fileBytes,
          filename: fileName,
        ),
      );

      // Send request
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      print('Resume upload response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Parse response to get the server-generated filename
        final responseData = json.decode(response.body);
        final serverFileName = responseData['fileName'] as String;
        
        // Save the server-generated filename to local preferences
        await prefs.setString('resumeUrl', serverFileName);
        return serverFileName;
      } else {
        print('Failed to upload resume: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading resume to backend: $e');
      return null;
    }
  }

  // Save resume URL to preferences (local)
  static Future<bool> saveResumeUrl(String resumeUrl) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('resumeUrl', resumeUrl);
      return true;
    } catch (e) {
      print('Error saving resume URL: $e');
      return false;
    }
  }

  // Get saved resume URL
  static Future<String?> getResumeUrl() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('resumeUrl');
    } catch (e) {
      print('Error getting resume URL: $e');
      return null;
    }
  }

  // Download resume from backend
  static Future<void> downloadResume(String fileName) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('No authentication token found');
        return;
      }

      final String downloadUrl = '${Config.baseUrl}/api/users/resume/download/$fileName';
      
      print('Downloading resume from: $downloadUrl');
      
      // For web, use dart:html to download the file
      if (kIsWeb) {
        final request = http.Request('GET', Uri.parse(downloadUrl));
        request.headers['Authorization'] = 'Bearer $token';
        
        final response = await request.send();
        if (response.statusCode == 200) {
          final bytes = await response.stream.toBytes();
          // Create blob and download for web
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute("download", fileName)
            ..click();
          html.Url.revokeObjectUrl(url);
        }
      }
    } catch (e) {
      print('Error downloading resume: $e');
      rethrow;
    }
  }
}

