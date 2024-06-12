import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;
  String? _profilePictureUrl;
  User? get user => _user;
  String? get profilePictureUrl => _profilePictureUrl;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _profilePictureUrl = user.photoURL;
      } else {
        _profilePictureUrl = null;
      }
      notifyListeners(); // Notify listeners when user changes
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final userId = userCredential.user!.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'displayName': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'photoURL': userCredential.user!.photoURL,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'displayName': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'photoURL': userCredential.user!.photoURL,
        });
      }

      return userCredential;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
