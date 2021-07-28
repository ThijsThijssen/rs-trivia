import 'package:json_annotation/json_annotation.dart';

part 'high_score.g.dart';

@JsonSerializable(explicitToJson: true)
class HighScore {
  String username;
  int bloodhoundPets;
  int masterCluesOpened;
  double masterCluesProgress;
  int eliteCluesOpened;
  double eliteCluesProgress;
  int hardCluesOpened;
  double hardCluesProgress;
  int mediumCluesOpened;
  double mediumCluesProgress;
  int easyCluesOpened;
  double easyCluesProgress;
  int beginnerCluesOpened;
  double beginnerCluesProgress;

  HighScore(
      {this.username,
      this.bloodhoundPets,
      this.masterCluesOpened,
      this.masterCluesProgress,
      this.eliteCluesOpened,
      this.eliteCluesProgress,
      this.hardCluesOpened,
      this.hardCluesProgress,
      this.mediumCluesOpened,
      this.mediumCluesProgress,
      this.easyCluesOpened,
      this.easyCluesProgress,
      this.beginnerCluesOpened,
      this.beginnerCluesProgress});

  factory HighScore.fromJson(Map<String, dynamic> json) =>
      _$HighScoreFromJson(json);

  Map<String, dynamic> toJson() => _$HighScoreToJson(this);
}
