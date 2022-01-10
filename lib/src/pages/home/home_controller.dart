import 'package:flutter/material.dart';
import 'package:uber_clone/src/providers/auth_provider.dart';
import 'package:uber_clone/src/utils/shared_prefs.dart';

class HomeController {
  late BuildContext context;
  late SharedPrefs _sharedPrefs;
  late AuthProvider _authProvider;
  String? _userType;

  Future? init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();

    this._sharedPrefs = new SharedPrefs();
    _userType = await this._sharedPrefs.read('userType');
    print('HomeController');
    _authProvider.redirectUser(context, _userType);
  }

  void goToLoginPage(String userType) async {
    await this._sharedPrefs.save('userType', userType);
    Navigator.pushNamed(context, 'login');
  }
}
