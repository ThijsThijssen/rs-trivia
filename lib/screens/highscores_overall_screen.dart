import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rstrivia/widgets/player_highscore_tile.dart';

class HighscoresOverallScreen extends StatefulWidget {
  static final String id = 'highscores_screen';

  @override
  _HighscoresOverallScreenState createState() =>
      _HighscoresOverallScreenState();
}

class _HighscoresOverallScreenState extends State<HighscoresOverallScreen> {
  final _formKey = GlobalKey<FormState>();

  String _playerSearchTerm;
  final _playerSearchController = TextEditingController();

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Highscores',
          style: TextStyle(
            fontFamily: 'Runescape',
            fontSize: 48.0,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            _createSearchPlayerForm(),
            Expanded(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _createPlayerHighscoreTiles(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _playerSearchController.dispose();
    super.dispose();
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

//      log(_playerSearchTerm);

      _playerSearchController.clear();
    }
  }

  _clear() {
    _playerSearchController.clear();
  }

  Widget _createSearchPlayerForm() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              child: IconButton(
                onPressed: _clear,
                icon: Icon(Icons.clear),
                iconSize: 25.0,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: TextFormField(
                  controller: _playerSearchController,
                  decoration: InputDecoration(labelText: 'Search by username'),
                  validator: (input) =>
                      input.trim().isEmpty ? 'Enter a username' : null,
                  onSaved: (input) => _playerSearchTerm = input,
                  style: TextStyle(
                    fontFamily: 'Runescape',
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _submit,
              icon: Icon(Icons.search),
              iconSize: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _createPlayerHighscoreTiles() {
    List<Widget> widgets = List();

    // get all player highscores information

    for (int i = 0; i < 100; i++) {
      widgets.add(PlayerHighscoreTile(
        rank: i + 1,
        username: getRandomString(12),
        totalOpened: 1337 - i,
        profileImage: FontAwesomeIcons.userAlt,
      ));
    }

    // loop through every player

    // create player highscore tile

    return widgets;
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
