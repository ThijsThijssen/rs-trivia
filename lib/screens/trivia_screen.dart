import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rstrivia/constants.dart';
import 'package:rstrivia/domain/trivia_question.dart';
import 'package:rstrivia/domain/user_data.dart';
import 'package:rstrivia/extensions/string_extension.dart';
import 'package:rstrivia/service_locator.dart';
import 'package:rstrivia/services/user_data_service.dart';
import 'package:rstrivia/widgets/alert_dialog_close_button.dart';
import 'package:rstrivia/widgets/alert_dialog_text.dart';
import 'package:rstrivia/widgets/alert_dialog_title.dart';
import 'package:rstrivia/widgets/clue_scroll_tile.dart';
import 'package:rstrivia/widgets/title_text.dart';

class TriviaScreen extends StatefulWidget {
  static final String id = 'trivia_screen';

  @override
  _TriviaScreenState createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  final _auth = FirebaseAuth.instance;
  var currentUser;

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
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: userData != null ? _initializeContent() : [],
            ),
          ],
        ),
      ),
    );
  }

  _getUserData() async {
    setState(() {
      showSpinner = true;
    });

    currentUser = _auth.currentUser;
    userData = await userDataService.getUserData(currentUser.uid);

    setState(() {
      showSpinner = false;
    });
  }

  List<Widget> _initializeContent() {
    List<Widget> widgets = List();

    widgets.add(TitleText(
      title: 'Trivia Levels',
    ));

    widgets.add(_createClueScrollTile(kBeginnerTier, kBeginnerTier, 0.0));
    widgets
        .add(_createClueScrollTile(kEasyTier, kBeginnerTier, kTierUnlockedAt));
    widgets.add(_createClueScrollTile(kMediumTier, kEasyTier, kTierUnlockedAt));
    widgets.add(_createClueScrollTile(kHardTier, kMediumTier, kTierUnlockedAt));
    widgets.add(_createClueScrollTile(kEliteTier, kHardTier, kTierUnlockedAt));
    widgets
        .add(_createClueScrollTile(kMasterTier, kEliteTier, kTierUnlockedAt));

    return widgets;
  }

  _showCorrectAnswerDialog(String tier, int rewardAmount) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AlertDialogTitle(
              text: 'Correct answer!',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  AlertDialogText(
                    text:
                        'Congratulations! You are now on a win streak of ${userData.getWinStreakByTier(tier)}!',
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AlertDialogText(
                    text:
                        'You selected the correct answer, and are rewarded $rewardAmount ${tier.capitalize()} Reward Casket.',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              AlertDialogCloseButton(),
            ],
          );
        });
  }

  _showIncorrectAnswerDialog(String correctAnswer) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AlertDialogTitle(
              text: 'Incorrect answer!',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  AlertDialogText(
                    text:
                        'Unfortunately you selected the incorrect answer, the correct answer was $correctAnswer.',
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  AlertDialogText(
                    text: 'Your win streak has been reset to 0.',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              AlertDialogCloseButton(),
            ],
          );
        });
  }

  List<Widget> _getTriviaQuestionDialogWidgets(TriviaQuestion triviaQuestion) {
    List<Widget> widgets = List();

    widgets.add(AlertDialogText(text: triviaQuestion.question));
    widgets.add(SizedBox(height: 10.0));
    widgets.addAll(_createAnswerWidgets(triviaQuestion));

    return widgets;
  }

  _showTriviaQuestionDialog(TriviaQuestion triviaQuestion) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AlertDialogTitle(
              text: '${triviaQuestion.tier.capitalize()} Clue Scroll',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: _getTriviaQuestionDialogWidgets(triviaQuestion),
              ),
            ),
            actions: <Widget>[
              AlertDialogCloseButton(),
            ],
          );
        });
  }

  int _getWinStreakRewardAmount(int winStreak) {
    int rewardAmount = 1;

    if (winStreak % 100 == 0) {
      rewardAmount = 100;
    } else if (winStreak % 75 == 0) {
      rewardAmount = 75;
    } else if (winStreak % 50 == 0) {
      rewardAmount = 50;
    } else if (winStreak % 25 == 0) {
      rewardAmount = 25;
    } else if (winStreak % 10 == 0) {
      rewardAmount = 10;
    } else if (winStreak % 5 == 0) {
      rewardAmount = 5;
    }

    return rewardAmount * userData.rewardCasketMultiplier;
  }

  void _handleCorrectAnswer(TriviaQuestion triviaQuestion) {
    userData.incrementWinStreakByTier(triviaQuestion.tier);

    int winStreak = userData.getWinStreakByTier(triviaQuestion.tier);
    int rewardAmount = _getWinStreakRewardAmount(winStreak);

    userData.addRewardCasketAmount(triviaQuestion.tier, rewardAmount);

    userDataService.updateUserData(userData, currentUser.uid);
    Navigator.of(context).pop();
    _showCorrectAnswerDialog(triviaQuestion.tier, rewardAmount);
  }

  void _handleIncorrectAnswer(TriviaQuestion triviaQuestion) {
    userData.resetWinStreakByTier(triviaQuestion.tier);
    userDataService.updateUserData(userData, currentUser.uid);
    Navigator.of(context).pop();
    _showIncorrectAnswerDialog(triviaQuestion.correctAnswer);
  }

  List<Widget> _createAnswerWidgets(TriviaQuestion triviaQuestion) {
    List<Widget> widgets = List();

    triviaQuestion.answers.shuffle();

    for (String answer in triviaQuestion.answers) {
      if (answer == triviaQuestion.correctAnswer) {
        widgets.add(
          RaisedButton(
            onPressed: () {
              _handleCorrectAnswer(triviaQuestion);
            },
            child: AlertDialogText(
              text: answer,
            ),
          ),
        );
      } else {
        widgets.add(
          RaisedButton(
            onPressed: () {
              _handleIncorrectAnswer(triviaQuestion);
            },
            child: AlertDialogText(
              text: answer,
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _createClueScrollTile(
      String tier, String previousTier, double unlockedAt) {
    return ClueScrollTile(
      name: userData.getTriviaLevelByTier(tier).tier,
      progress: userData.getProgressByTier(tier),
      unlocked:
          userData.getProgressByTier(previousTier) >= unlockedAt ? true : false,
      onTap: () {
        _showTriviaQuestionDialog(userData.getRandomTriviaQuestionByTier(tier));
      },
    );
  }
}
