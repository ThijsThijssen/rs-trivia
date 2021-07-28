import 'package:flutter/material.dart';

class AlertDialogCloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Close',
        style: TextStyle(
          fontFamily: 'Runescape',
          fontSize: 23.0,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
