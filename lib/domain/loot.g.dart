// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loot _$LootFromJson(Map<String, dynamic> json) {
  return Loot(
    name: json['name'] as String,
    quantity: json['quantity'] as int,
  );
}

Map<String, dynamic> _$LootToJson(Loot instance) => <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
    };
