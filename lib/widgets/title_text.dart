import 'package:flutter/material.dart';
import 'package:rstrivia/extensions/string_extension.dart';

class TitleText extends StatelessWidget {
  final String title;

  TitleText({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        '${title.capitalize()}',
        style: TextStyle(
          fontFamily: 'Runescape',
          fontSize: 40.0,
        ),
      ),
    );
  }
}
