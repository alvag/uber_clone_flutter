import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clone/src/providers/auth_provider.dart';
import 'package:uber_clone/src/utils/custom_progress_dialog.dart';
import 'package:uber_clone/src/utils/custom_snackbar.dart';

class LoginController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();

  late AuthProvider _authProvider;
  late ProgressDialog _progressDialog;

  Future? init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _progressDialog = CustomProgressDialog.createProgressDialog(context, 'Espere un momento...');
  }

  void login() async {
    String email = this.emailController.text.trim();
    String password = this.pwdController.text;

    _progressDialog.show();

    try {
      await _authProvider.login(email, password);
      _progressDialog.hide();
    } catch (error) {
      _progressDialog.hide();
      print('Error: $error');
      CustomSnackBar.show(context, key, 'Usuario no se pudo autenticar');
    }
  }

  void goToRegister() {
    Navigator.pushNamed(context, 'register');
  }
}
