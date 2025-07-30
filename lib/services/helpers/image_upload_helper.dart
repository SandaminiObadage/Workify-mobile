import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadHelper {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to Firebase Storage and get download URL
  static Future<String?> uploadImage(File imageFile, String folder) async {
    try {
      // Create unique filename
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create reference to Firebase Storage
      Reference ref = _storage.ref().child('$folder/$fileName.jpg');
      
      // Upload file
      UploadTask uploadTask = ref.putFile(imageFile);
      
      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;
      
      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Pick and upload image
  static Future<String?> pickAndUploadImage(String folder) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        File imageFile = File(image.path);
        return await uploadImage(imageFile, folder);
      }
      
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
}
