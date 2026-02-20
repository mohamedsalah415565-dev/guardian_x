import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService._(); // private constructor to prevent instantiation

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a file to Firebase Storage under 'profile_images/{uid}.jpg'
  /// Returns the download URL of the uploaded file
  static Future<String> uploadProfileImage({
    required String uid,
    required File file,
  }) async {
    try {
      final ref = _storage.ref().child("profile_images/$uid.jpg");

      // Upload the file
      await ref.putFile(file);

      // Get the download URL
      final url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      throw "Failed to upload profile image: $e";
    }
  }
}
