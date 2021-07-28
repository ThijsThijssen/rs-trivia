import 'package:json_annotation/json_annotation.dart';

part 'trivia_level.g.dart';

@JsonSerializable(explicitToJson: true)
class TriviaLevel {
  TriviaLevel(this.tier, this.progress, this.unlocked);

  String tier;
  double progress;
  bool unlocked;

  factory TriviaLevel.fromJson(Map<String, dynamic> json) =>
      _$TriviaLevelFromJson(json);

  Map<String, dynamic> toJson() => _$TriviaLevelToJson(this);
}
