import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomSnackBar {
  static void show(BuildContext context, GlobalKey<ScaffoldState> key, String text) {
    if (key.currentState != null) {
      FocusScope.of(context).requestFocus(new FocusNode());

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: CustomColors.uberCloneColor,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
