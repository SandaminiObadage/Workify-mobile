import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/services/helpers/resume_helper.dart';

class ResumeProvider extends ChangeNotifier {
  bool _isUploading = false;
  String? _resumeUrl;
  String? _errorMessage;
  bool _doneUploading = false;

  bool get isUploading => _isUploading;
  String? get resumeUrl => _resumeUrl;
  String? get errorMessage => _errorMessage;
  bool get doneUploading => _doneUploading;

  // Pick and upload resume
  Future<void> uploadResume() async {
    _isUploading = true;
    _doneUploading = false;
    _errorMessage = null;
    notifyListeners();

    try {
      String? url = await ResumeHelper.pickAndUploadResume();

      if (url != null) {
        _resumeUrl = url;
        _doneUploading = true;
        await ResumeHelper.saveResumeUrl(url);
        
        Get.snackbar(
          "Success",
          "Resume uploaded successfully",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      } else {
        _errorMessage = "Failed to upload resume or no file selected";
        Get.snackbar(
          "Info",
          "No resume selected or upload failed. Please try again.",
          colorText: Colors.white,
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.info, color: Colors.white),
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
      Get.snackbar(
        "Error",
        "An error occurred: ${e.toString()}",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  // Clear resume
  void clearResume() {
    _resumeUrl = null;
    _errorMessage = null;
    _doneUploading = false;
    notifyListeners();
  }

  // Load saved resume URL
  Future<void> loadSavedResume() async {
    try {
      String? url = await ResumeHelper.getResumeUrl();
      if (url != null) {
        _resumeUrl = url;
        notifyListeners();
      }
    } catch (e) {
      print('Error loading resume: $e');
    }
  }

  // Download resume
  Future<void> downloadResume() async {
    try {
      if (_resumeUrl == null) {
        Get.snackbar(
          "Error",
          "No resume available",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error, color: Colors.white),
        );
        return;
      }

      // Extract filename from path (e.g., /resumes/filename.pdf -> filename.pdf)
      final fileName = _resumeUrl!.split('/').last;
      
      // Call download helper
      await ResumeHelper.downloadResume(fileName);
      
      Get.snackbar(
        "Success",
        "Resume downloading...",
        colorText: Colors.white,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to download resume: $e",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }
}
