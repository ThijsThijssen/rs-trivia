// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_casket_amount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardCasketAmount _$RewardCasketAmountFromJson(Map<String, dynamic> json) {
  return RewardCasketAmount(
    json['tier'] as String,
    json['amount'] as int,
    json['unlocked'] as bool,
  );
}

Map<String, dynamic> _$RewardCasketAmountToJson(RewardCasketAmount instance) =>
    <String, dynamic>{
      'tier': instance.tier,
      'amount': instance.amount,
      'unlocked': instance.unlocked,
    };
