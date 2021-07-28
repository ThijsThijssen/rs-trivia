// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trivia_level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TriviaLevel _$TriviaLevelFromJson(Map<String, dynamic> json) {
  return TriviaLevel(
    json['tier'] as String,
    (json['progress'] as num)?.toDouble(),
    json['unlocked'] as bool,
  );
}

Map<String, dynamic> _$TriviaLevelToJson(TriviaLevel instance) =>
    <String, dynamic>{
      'tier': instance.tier,
      'progress': instance.progress,
      'unlocked': instance.unlocked,
    };
