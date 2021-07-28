import 'package:json_annotation/json_annotation.dart';

part 'win_streak.g.dart';

@JsonSerializable(explicitToJson: true)
class WinStreak {
  String tier;
  int winStreak;

  WinStreak({this.tier, this.winStreak});

  factory WinStreak.fromJson(Map<String, dynamic> json) =>
      _$WinStreakFromJson(json);

  Map<String, dynamic> toJson() => _$WinStreakToJson(this);
}
