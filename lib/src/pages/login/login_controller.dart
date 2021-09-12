import 'package:flutter/material.dart';

class LoginController {
  BuildContext? context;

  TextEditingController emailController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();

  Future? init(BuildContext context) {
    this.context = context;
  }

  void login() {
    String email = this.emailController.text;
    String password = this.pwdController.text;

    print('Email: $email');
    print('Password: $password');
  }
}
