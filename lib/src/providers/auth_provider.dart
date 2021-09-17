import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  late FirebaseAuth _firebaseAuth;

  AuthProvider() {
    _firebaseAuth = FirebaseAuth.instance;
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
}
