import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider {
  late FirebaseAuth _firebaseAuth;

  AuthProvider() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<void> logOut() async {
    return _firebaseAuth.signOut();
  }

  Future<bool> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (error) {
      print(error);
      return Future.error(error.code);
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (error) {
      print(error);
      return Future.error(error.code);
    }
  }

  User? getUser() {
    return _firebaseAuth.currentUser;
  }

  void checkIfUserIsLogged(BuildContext context, String? userType) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      print('checkIfUserIsLogged $userType');
      if (user != null && userType != null) {
        if (userType == 'client') {
          Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
        }
      }
    });
  }

  bool isLoggedIn() {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return false;
    return true;
  }

  void redirectUser(BuildContext context, String? userType) {
    if (isLoggedIn() && userType != null) {
      if (userType == 'client') {
        Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
      }
    }
  }
}
