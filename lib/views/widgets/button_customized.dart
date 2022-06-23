import 'package:flutter/material.dart';

class ButtonCustomized extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback? onPressed;

  ButtonCustomized(
      {required this.text,
      this.textColor = Colors.white,
      this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6)
      ),
        color: const Color(0xff9c27b0),
        onPressed: onPressed,
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: textColor),
        ));
  }
}
