import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rstrivia/screens/home_screen.dart';
import 'package:rstrivia/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  String _email, _password;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // OSRS Trivia
                  TypewriterAnimatedTextKit(
                    text: ['OSRS Trivia'],
                    textStyle: TextStyle(
                      fontFamily: 'Runescape',
                      fontSize: 50.0,
                    ),
                    speed: Duration(
                      milliseconds: 800,
                    ),
                  ),
                  // beginnerClue, bloodhound pet, masterClue
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                            'assets/img/misc/clue_scroll_beginner.png'),
                        width: 75.0,
                      ),
                      Image(
                        image:
                            AssetImage('assets/img/items/bloodhound_pet.png'),
                        width: 75.0,
                      ),
                      Image(
                        image: AssetImage(
                            'assets/img/misc/clue_scroll_master.png'),
                        width: 75.0,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 25.0,
                  ),

                  // Email input field
                  // Password input field
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 50.0,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                            validator: (input) => input.trim().isEmpty
                                ? 'Email can\'t be empty'
                                : null,
                            onSaved: (input) => _email = input,
                            style: TextStyle(
                              fontFamily: 'Runescape',
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 50.0,
                            vertical: 15.0,
                          ),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            validator: (input) => input.trim().isEmpty
                                ? 'Password can\'t be empty'
                                : null,
                            onSaved: (input) => _password = input,
                            style: TextStyle(
                              fontFamily: 'Runescape',
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 25.0,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Login button
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 50.0,
                              ),
                              child: RaisedButton.icon(
                                onPressed: () {
                                  _submit();
                                },
                                icon: Icon(
                                  FontAwesomeIcons.signInAlt,
                                  size: 30.0,
                                ),
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 5.0,
                                  ),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontFamily: 'Runescape',
                                      fontSize: 35.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 10.0,
                      ),

                      // Registration button
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 50.0,
                              ),
                              child: RaisedButton.icon(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(RegistrationScreen.id);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.userPlus,
                                  size: 30.0,
                                ),
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 5.0,
                                  ),
                                  child: Text(
                                    'Registration',
                                    style: TextStyle(
                                      fontFamily: 'Runescape',
                                      fontSize: 35.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        showSpinner = true;
      });

      try {
        final session = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);

        if (session != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);
          setState(() {
            showSpinner = true;
          });
        }
      } catch (e) {
        print(e);
        setState(() {
          showSpinner = true;
        });
      }

      _emailController.clear();
      _passwordController.clear();
    }
  }
}
