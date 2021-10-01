import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clone/src/models/client.dart';
import 'package:uber_clone/src/providers/auth_provider.dart';
import 'package:uber_clone/src/providers/client_provider.dart';
import 'package:uber_clone/src/utils/custom_progress_dialog.dart';
import 'package:uber_clone/src/utils/custom_snackbar.dart';

class RegisterController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  late AuthProvider _authProvider;
  late ClientProvider _clientProvider;
  late ProgressDialog _progressDialog;

  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  TextEditingController pwdConfirmController = new TextEditingController();

  Future? init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    _progressDialog = CustomProgressDialog.createProgressDialog(context, 'Espere un momento...');
  }

  void register() async {
    String email = this.emailController.text.trim();
    String username = this.usernameController.text.trim();
    String password = this.pwdController.text;
    String confirmPassword = this.pwdConfirmController.text;

    if (email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      CustomSnackBar.show(context, key, 'Debes ingresar todos los datos');
      return;
    }

    if (password != confirmPassword) {
      CustomSnackBar.show(context, key, 'Las contraseñas deben ser iguales');
      return;
    }

    _progressDialog.show();

    try {
      await _authProvider.register(email, password);
      Client client = new Client(
        id: _authProvider.getUser()!.uid,
        email: email,
        username: username,
        password: password,
      );
      await _clientProvider.create(client);
      _progressDialog.hide();
      this.emailController.clear();
      this.usernameController.clear();
      this.pwdController.clear();
      this.pwdConfirmController.clear();
      CustomSnackBar.show(context, key, 'Usuario registrado');
    } catch (error) {
      _progressDialog.hide();
      CustomSnackBar.show(context, key, 'Error: $error');
    }
  }
}
