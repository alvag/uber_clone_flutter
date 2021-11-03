import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clone/src/models/driver.dart';
import 'package:uber_clone/src/providers/auth_provider.dart';
import 'package:uber_clone/src/providers/driver_provider.dart';
import 'package:uber_clone/src/utils/custom_progress_dialog.dart';
import 'package:uber_clone/src/utils/custom_snackbar.dart';

class DriverRegisterController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  late AuthProvider _authProvider;
  late DriverProvider _driverProvider;
  late ProgressDialog _progressDialog;

  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  TextEditingController pwdConfirmController = new TextEditingController();

  // OTP Fields
  TextEditingController pin1Controller = new TextEditingController();
  TextEditingController pin2Controller = new TextEditingController();
  TextEditingController pin3Controller = new TextEditingController();
  TextEditingController pin4Controller = new TextEditingController();
  TextEditingController pin5Controller = new TextEditingController();
  TextEditingController pin6Controller = new TextEditingController();

  Future? init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _progressDialog = CustomProgressDialog.createProgressDialog(context, 'Espere un momento...');
  }

  void register() async {
    String email = this.emailController.text.trim();
    String username = this.usernameController.text.trim();
    String password = this.pwdController.text;
    String confirmPassword = this.pwdConfirmController.text;

    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();

    String plate = '$pin1$pin2$pin3 - $pin4$pin5$pin6';

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
      Driver driver = new Driver(id: _authProvider.getUser()!.uid, email: email, username: username, password: password, plate: plate);
      await _driverProvider.create(driver);
      _progressDialog.hide();
      this.emailController.clear();
      this.usernameController.clear();
      this.pwdController.clear();
      this.pwdConfirmController.clear();
      Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
    } catch (error) {
      _progressDialog.hide();
      CustomSnackBar.show(context, key, 'Error: $error');
    }
  }
}
