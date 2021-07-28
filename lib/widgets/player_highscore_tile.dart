import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../extensions/string_extension.dart';

class PlayerHighscoreTile extends StatefulWidget {
  final int rank;
  final String username;
  final int totalOpened;
  final IconData profileImage;

  PlayerHighscoreTile(
      {this.rank, this.username, this.totalOpened, this.profileImage});

  @override
  _PlayerHighscoreTileState createState() => _PlayerHighscoreTileState();
}

class _PlayerHighscoreTileState extends State<PlayerHighscoreTile> {
  var numberFormatter = NumberFormat('#,##0', 'en_US');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Card(
          child: ListTile(
            leading: Icon(
              widget.profileImage,
              size: 50.0,
            ),
            title: Text(
              'Rank ${widget.rank}: ${widget.username.capitalize()}',
              style: TextStyle(
                fontFamily: 'Runescape',
                fontSize: 23.0,
              ),
            ),
            subtitle: Text(
              'Caskets opened: ${numberFormatter.format(widget.totalOpened)}',
              style: TextStyle(
                fontFamily: 'Runescape',
                fontSize: 20.0,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                log('${widget.username} has been pressed');
              },
              child: Icon(FontAwesomeIcons.userAlt),
            ),
          ),
        ),
      ),
    );
  }
}
