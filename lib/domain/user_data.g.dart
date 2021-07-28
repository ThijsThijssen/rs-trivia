// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    (json['triviaQuestions'] as List)
        ?.map((e) => e == null
            ? null
            : TriviaQuestion.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['triviaLevels'] as List)
        ?.map((e) =>
            e == null ? null : TriviaLevel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['rewardCasketAmounts'] as List)
        ?.map((e) => e == null
            ? null
            : RewardCasketAmount.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['collectionLog'] as List)
        ?.map((e) => e == null
            ? null
            : CollectionLogTier.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['totalLoot'] as List)
        ?.map(
            (e) => e == null ? null : Loot.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['winStreaks'] as List)
        ?.map((e) =>
            e == null ? null : WinStreak.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['longPressedOpenAmount'] as int,
    json['longPressedOpenAmountUnlocked'] as int,
    json['rewardCasketMultiplier'] as int,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'triviaQuestions':
          instance.triviaQuestions?.map((e) => e?.toJson())?.toList(),
      'triviaLevels': instance.triviaLevels?.map((e) => e?.toJson())?.toList(),
      'rewardCasketAmounts':
          instance.rewardCasketAmounts?.map((e) => e?.toJson())?.toList(),
      'collectionLog':
          instance.collectionLog?.map((e) => e?.toJson())?.toList(),
      'totalLoot': instance.totalLoot?.map((e) => e?.toJson())?.toList(),
      'winStreaks': instance.winStreaks?.map((e) => e?.toJson())?.toList(),
      'longPressedOpenAmount': instance.longPressedOpenAmount,
      'longPressedOpenAmountUnlocked': instance.longPressedOpenAmountUnlocked,
      'rewardCasketMultiplier': instance.rewardCasketMultiplier,
    };
