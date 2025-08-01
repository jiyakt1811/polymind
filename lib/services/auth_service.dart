import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email/Password Sign Up
  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
    UserModel userData,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Save user data to Firestore
        await _saveUserData(result.user!.uid, userData);
      }

      return result;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Email/Password Sign In
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Google Sign In
  Future<UserCredential?> signInWithGoogle(UserModel userData) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        // Save user data to Firestore
        await _saveUserData(result.user!.uid, userData);
      }

      return result;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserData(String uid, UserModel userData) async {
    try {
      UserModel userWithUid = userData.copyWith(uid: uid);
      await _firestore
          .collection('users')
          .doc(uid)
          .set(userWithUid.toMap());
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user data
  Future<void> updateUserData(String uid, UserModel userData) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update(userData.toMap());
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
} 