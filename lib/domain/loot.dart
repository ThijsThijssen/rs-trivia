import 'package:json_annotation/json_annotation.dart';

part 'loot.g.dart';

@JsonSerializable(explicitToJson: true)
class Loot {
  String name;
  int quantity;

  Loot({this.name, this.quantity});

  factory Loot.fromJson(Map<String, dynamic> json) => _$LootFromJson(json);

  Map<String, dynamic> toJson() => _$LootToJson(this);
}
