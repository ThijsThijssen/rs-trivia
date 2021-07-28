import 'package:flutter/material.dart';

class AlertDialogText extends StatelessWidget {
  final String text;
  AlertDialogText({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: TextStyle(
        fontFamily: 'Runescape',
        fontSize: 20.0,
      ),
    );
  }
}
