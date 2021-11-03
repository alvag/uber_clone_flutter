import 'package:flutter/material.dart';
import 'package:uber_clone/src/utils/custom_colors.dart';

class CustomButton extends StatelessWidget {
  final Color? btnColor;
  final Color? textColor;
  final String text;
  final IconData? icon;
  final Function onPressed;

  CustomButton({
    this.btnColor = CustomColors.uberCloneColor,
    required this.text,
    this.textColor = Colors.white,
    this.icon = Icons.arrow_forward_ios,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      onPrimary: this.textColor,
      primary: this.btnColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );

    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 50,
              child: CircleAvatar(
                radius: 15,
                child: Icon(icon, color: CustomColors.uberCloneColor),
                backgroundColor: Colors.white,
              ),
            ),
          )
        ],
      ),
      style: buttonStyle,
    );
  }
}
