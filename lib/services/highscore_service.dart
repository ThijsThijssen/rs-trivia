import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rstrivia/domain/high_score.dart';

class HighscoreService {
  final _firestore = FirebaseFirestore.instance;

  Future createNewEntry(String uid, String username) async {
    HighScore highScore = HighScore(
        username: username,
        bloodhoundPets: 0,
        masterCluesOpened: 0,
        masterCluesProgress: 0.0,
        eliteCluesOpened: 0,
        eliteCluesProgress: 0.0,
        hardCluesOpened: 0,
        hardCluesProgress: 0.0,
        mediumCluesOpened: 0,
        mediumCluesProgress: 0.0,
        easyCluesOpened: 0,
        easyCluesProgress: 0.0,
        beginnerCluesOpened: 0,
        beginnerCluesProgress: 0.0);
    await _firestore.collection('highscores').doc(uid).set(highScore.toJson());
  }
}
