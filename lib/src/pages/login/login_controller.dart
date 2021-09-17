import 'package:flutter/material.dart';
import 'package:uber_clone/src/providers/auth_provider.dart';

class LoginController {
  late BuildContext context;

  TextEditingController emailController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();

  late AuthProvider _authProvider;

  Future? init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
  }

  void login() async {
    String email = this.emailController.text.trim();
    String password = this.pwdController.text;

    try {
      bool isLoggedIn = await _authProvider.login(email, password);
      if (isLoggedIn) {
        print("Usuario logueado");
      } else {
        print("Usuario no se pudo autenticar");
      }
    } catch (error) {
      print(error);
    }
  }

  void goToRegister() {
    Navigator.pushNamed(context, 'register');
  }
}
