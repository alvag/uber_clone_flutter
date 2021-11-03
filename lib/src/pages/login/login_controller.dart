import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber_clone/src/models/client.dart';
import 'package:uber_clone/src/models/driver.dart';
import 'package:uber_clone/src/providers/auth_provider.dart';
import 'package:uber_clone/src/providers/client_provider.dart';
import 'package:uber_clone/src/providers/driver_provider.dart';
import 'package:uber_clone/src/utils/custom_progress_dialog.dart';
import 'package:uber_clone/src/utils/custom_snackbar.dart';
import 'package:uber_clone/src/utils/shared_prefs.dart';

class LoginController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();

  late AuthProvider _authProvider;
  late DriverProvider _driverProvider;
  late ClientProvider _clientProvider;

  late ProgressDialog _progressDialog;

  late SharedPrefs _sharedPrefs;
  late String _userType;

  Future? init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();

    _progressDialog = CustomProgressDialog.createProgressDialog(context, 'Espere un momento...');

    _sharedPrefs = new SharedPrefs();
    _userType = await _sharedPrefs.read('userType');
  }

  void login() async {
    String email = this.emailController.text.trim();
    String password = this.pwdController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      _progressDialog.show();

      try {
        await _authProvider.login(email, password);

        final userId = _authProvider.getUser()!.uid;

        if (_userType == 'client') {
          Client? client = await _clientProvider.getById(userId);
          if (client != null) {
            onSuccessLogin();
          } else {
            onErrorLogin();
          }
        } else {
          Driver? driver = await _driverProvider.getById(userId);
          if (driver != null) {
            onSuccessLogin();
          } else {
            onErrorLogin();
          }
        }
      } catch (error) {
        _progressDialog.hide();
        print('Error: $error');
        CustomSnackBar.show(context, key, 'Usuario no se pudo autenticar');
      }
    }
  }

  void onErrorLogin() async {
    _progressDialog.hide();
    CustomSnackBar.show(context, key, 'Usuario no válido');
    await _authProvider.logOut();
  }

  void onSuccessLogin() {
    _progressDialog.hide();
    _authProvider.redirectUser(context, _userType);
  }

  void goToRegister() {
    if (_userType == 'client') {
      Navigator.pushNamed(context, 'client/register');
    } else {
      Navigator.pushNamed(context, 'driver/register');
    }
  }
}
