import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithGoogle({String role = 'learner'}) async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential with the Google Access Token
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during Google Sign In';
    }
  }

  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String role = 'learner',
  }) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _saveUserRole(
        userCredential.user?.uid, 
        role, 
        name, 
        email,
      );

      await userCredential.user?.updateDisplayName(name);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during Google Sign In';
    }
  }

  Future<void> _saveUserRole(
    String? uid, 
    String role, 
    String? name, 
    String? email
  ) async {
    if (uid == null) return;

    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user role: $e');
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during sign up';
    }
  }

  Future<void> signOut() async {
    try {
      // await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Sign out error: $e");
      throw 'An error occurred during sign out';
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak';
      case 'email-already-in-use':
        return 'An account already exists for that email';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'user-not-found':
        return 'No user found for that email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'invalid-credential':
        return 'Invalid credential';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials';
      case 'expired-action-code':
        return 'The password reset link has expired';
      case 'invalid-action-code':
        return 'The password reset link is invalid';
      default:
        return 'An error occurred. Please try again. (${e.code})';
    }
  }
}