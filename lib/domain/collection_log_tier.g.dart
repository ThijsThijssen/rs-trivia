// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_log_tier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionLogTier _$CollectionLogTierFromJson(Map<String, dynamic> json) {
  return CollectionLogTier(
    json['tier'] as String,
    json['casketsOpened'] as int,
    (json['uniques'] as List)
        ?.map(
            (e) => e == null ? null : Loot.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CollectionLogTierToJson(CollectionLogTier instance) =>
    <String, dynamic>{
      'tier': instance.tier,
      'casketsOpened': instance.casketsOpened,
      'uniques': instance.uniques?.map((e) => e?.toJson())?.toList(),
    };
