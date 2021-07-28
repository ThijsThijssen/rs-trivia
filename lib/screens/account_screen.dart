import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rstrivia/domain/user_data.dart';
import 'package:rstrivia/screens/home_screen.dart';
import 'package:rstrivia/screens/login_screen.dart';
import 'package:rstrivia/service_locator.dart';
import 'package:rstrivia/services/user_data_service.dart';
import 'package:rstrivia/widgets/image_capture.dart';
import 'package:rstrivia/widgets/title_text.dart';

class AccountScreen extends StatefulWidget {
  static final String id = 'account_screen';

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _auth = FirebaseAuth.instance;

  UserDataService userDataService = locator<UserDataService>();
  UserData userData;

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          },
        ),
        title: Text(
          'Account',
          style: TextStyle(
            fontFamily: 'Runescape',
            fontSize: 48.0,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.signOutAlt),
              onPressed: () {
                setState(() {
                  _auth.signOut();
                });
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: userData != null ? _initializeContent() : [],
              )
            ],
          ),
        ),
      ),
    );
  }

  _getUserData() async {
    setState(() {
      showSpinner = true;
    });

    userData = await userDataService.getUserData(_auth.currentUser.uid);

    setState(() {
      showSpinner = false;
    });
  }

  List<Widget> _initializeContent() {
    List<Widget> widgets = List();

    widgets.add(TitleText(
      title: '${_auth.currentUser.displayName}',
    ));

    widgets.add(Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(_auth.currentUser.photoURL))),
    ));

    widgets.add(
        IconButton(icon: Icon(FontAwesomeIcons.userEdit), onPressed: () {}));

    widgets.add(SizedBox(
      height: 15.0,
    ));

    widgets.add(ImageCapture());

    return widgets;
  }
}
