import 'package:flutter/material.dart';

class AlertDialogTitle extends StatelessWidget {
  final String text;
  AlertDialogTitle({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: TextStyle(
        fontFamily: 'Runescape',
        fontSize: 28.0,
      ),
    );
  }
}
