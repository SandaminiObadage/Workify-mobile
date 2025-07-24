import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

class ImageUpoader extends ChangeNotifier {
  var uuid = Uuid();
  final ImagePicker _picker = ImagePicker();

  String? imageUrl;
  String? imagePath;

  bool _doneUploading = false;
  bool _isUploading = false;

  bool get doneUploading => _doneUploading;
  bool get isUploading => _isUploading;

  set uploading(bool newState) {
    _doneUploading = newState;
    notifyListeners();
  }

  set setUploading(bool newState) {
    _isUploading = newState;
    notifyListeners();
  }

  List<String> imageFil = [];

  void pickImage() async {
    try {
      XFile? _imageFile = await _picker.pickImage(source: ImageSource.gallery);

      if (_imageFile != null) {
        imageFil.add(_imageFile.path);
        imagePath = _imageFile.path;
        notifyListeners();
        
        // Start uploading
        setUploading = true;
        uploading = false; // Reset upload state
        
        String? uploadResult = await imageUpload(_imageFile);
        if (uploadResult != null) {
          uploading = true;
          setUploading = false;
          print('Image uploaded successfully: $uploadResult');
          notifyListeners();
        } else {
          // Remove from list if upload failed
          imageFil.removeLast();
          imagePath = null;
          setUploading = false;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      uploading = false;
      setUploading = false;
      notifyListeners();
    }
  }

  Future<String?> imageUpload(XFile upload) async {
    try {
      File image = File(upload.path);

      // Use the correct storage bucket from firebase options
      final ref = FirebaseStorage.instance
          .ref()
          .child("workify_images")
          .child("profile_images")
          .child("${uuid.v1()}.jpg");
      
      print('Uploading to path: workify_images/profile_images/${uuid.v1()}.jpg');
      
      UploadTask uploadTask = ref.putFile(image);
      
      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;
      
      if (snapshot.state == TaskState.success) {
        imageUrl = await ref.getDownloadURL();
        print('Upload successful. Download URL: $imageUrl');
        return imageUrl;
      } else {
        print('Upload failed. State: ${snapshot.state}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      // Reset upload state on error
      uploading = false;
      return null;
    }
  }

  void clearImage() {
    imageFil.clear();
    imagePath = null;
    imageUrl = null;
    _doneUploading = false;
    _isUploading = false;
    notifyListeners();
  }
}
