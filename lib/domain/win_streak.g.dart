// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'win_streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WinStreak _$WinStreakFromJson(Map<String, dynamic> json) {
  return WinStreak(
    tier: json['tier'] as String,
    winStreak: json['winStreak'] as int,
  );
}

Map<String, dynamic> _$WinStreakToJson(WinStreak instance) => <String, dynamic>{
      'tier': instance.tier,
      'winStreak': instance.winStreak,
    };
