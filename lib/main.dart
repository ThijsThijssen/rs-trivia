import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rstrivia/screens/account_screen.dart';
import 'package:rstrivia/screens/highscores_overall_screen.dart';
import 'package:rstrivia/screens/home_screen.dart';
import 'package:rstrivia/screens/login_screen.dart';
import 'package:rstrivia/screens/registration_screen.dart';
import 'package:rstrivia/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OSRS Trivia',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        routes: {
          AccountScreen.id: (context) => AccountScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          HighscoresOverallScreen.id: (context) => HighscoresOverallScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen()
        });
  }
}
