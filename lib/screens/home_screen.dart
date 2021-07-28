import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/screens/account_screen.dart';
import 'package:rstrivia/screens/collection_log_screen.dart';
import 'package:rstrivia/screens/highscores_overall_screen.dart';
import 'package:rstrivia/screens/reward_casket_screen.dart';
import 'package:rstrivia/screens/shop_screen.dart';
import 'package:rstrivia/screens/trivia_screen.dart';
import 'package:rstrivia/service_locator.dart';
import 'package:rstrivia/services/user_data_service.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserDataService fileService = locator<UserDataService>();

  List<Loot> loot = List();

  int _selectedIndex = 0;

  bool showSpinner = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> kBottomNavigationOptions = <Widget>[
    TriviaScreen(),
    RewardCasketScreen(),
    CollectionLogScreen(),
    ShopScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OSRS Trivia',
          style: TextStyle(
            fontFamily: 'Runescape',
            fontSize: 48.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.trophy),
            onPressed: () {
              setState(() {
                showSpinner = true;
              });
              Navigator.pushNamed(context, HighscoresOverallScreen.id);
              setState(() {
                showSpinner = false;
              });
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.userAlt),
            onPressed: () {
              Navigator.pushNamed(context, AccountScreen.id);
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: kBottomNavigationOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.question),
            title: Text(
              'Trivia',
              style: TextStyle(fontFamily: 'Runescape', fontSize: 20.0),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.briefcase),
            title: Text(
              'Reward Caskets',
              style: TextStyle(fontFamily: 'Runescape', fontSize: 20.0),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.book),
            title: Text(
              'Collection Log',
              style: TextStyle(fontFamily: 'Runescape', fontSize: 20.0),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.dollarSign),
            title: Text(
              'Shop',
              style: TextStyle(fontFamily: 'Runescape', fontSize: 20.0),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
