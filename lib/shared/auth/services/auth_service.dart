import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authState => _auth.authStateChanges();

  // --- Login ---
  static Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _message(e);
    }
  }

  // --- Register ---
  static Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _message(e);
    }
  }

  /// Reset password
  /// بتبعت إيميل للمستخدم عشان يغير الباسورد بتاعته
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _message(e);
    }
  }

  // --- Google Sign-In ---
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return {};

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) return {};

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? "",
          'email': user.email ?? "",
          'profile_image': user.photoURL ?? "",
          'created_at': FieldValue.serverTimestamp(),
          'role': 'user',
          'setup_complete': false,
        });
      }

      return {
        'user': user,
        'accessToken': googleAuth.accessToken,
        'idToken': googleAuth.idToken,
      };
    } catch (e) {
      throw "Google Sign-In failed: $e";
    }
  }

  // --- (FINALIZE USER PROFILE) ---
  static Future<void> finalizeUserProfile({
    required String uid,
    required String name,
    required String imagePath,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'profile_image': imagePath,
        'setup_complete': true,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw "Failed to save profile: $e";
    }
  }

  static Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  static String _message(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "User not found";
      case 'wrong-password':
        return "Wrong password";
      case 'email-already-in-use':
        return "Email already exists";
      default:
        return e.message ?? "Authentication error";
    }
  }
}
