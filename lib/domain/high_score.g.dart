// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'high_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HighScore _$HighScoreFromJson(Map<String, dynamic> json) {
  return HighScore(
    username: json['username'] as String,
    bloodhoundPets: json['bloodhoundPets'] as int,
    masterCluesOpened: json['masterCluesOpened'] as int,
    masterCluesProgress: (json['masterCluesProgress'] as num)?.toDouble(),
    eliteCluesOpened: json['eliteCluesOpened'] as int,
    eliteCluesProgress: (json['eliteCluesProgress'] as num)?.toDouble(),
    hardCluesOpened: json['hardCluesOpened'] as int,
    hardCluesProgress: (json['hardCluesProgress'] as num)?.toDouble(),
    mediumCluesOpened: json['mediumCluesOpened'] as int,
    mediumCluesProgress: (json['mediumCluesProgress'] as num)?.toDouble(),
    easyCluesOpened: json['easyCluesOpened'] as int,
    easyCluesProgress: (json['easyCluesProgress'] as num)?.toDouble(),
    beginnerCluesOpened: json['beginnerCluesOpened'] as int,
    beginnerCluesProgress: (json['beginnerCluesProgress'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$HighScoreToJson(HighScore instance) => <String, dynamic>{
      'username': instance.username,
      'bloodhoundPets': instance.bloodhoundPets,
      'masterCluesOpened': instance.masterCluesOpened,
      'masterCluesProgress': instance.masterCluesProgress,
      'eliteCluesOpened': instance.eliteCluesOpened,
      'eliteCluesProgress': instance.eliteCluesProgress,
      'hardCluesOpened': instance.hardCluesOpened,
      'hardCluesProgress': instance.hardCluesProgress,
      'mediumCluesOpened': instance.mediumCluesOpened,
      'mediumCluesProgress': instance.mediumCluesProgress,
      'easyCluesOpened': instance.easyCluesOpened,
      'easyCluesProgress': instance.easyCluesProgress,
      'beginnerCluesOpened': instance.beginnerCluesOpened,
      'beginnerCluesProgress': instance.beginnerCluesProgress,
    };
