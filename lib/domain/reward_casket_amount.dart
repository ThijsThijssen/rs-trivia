import 'package:json_annotation/json_annotation.dart';

part 'reward_casket_amount.g.dart';

@JsonSerializable(explicitToJson: true)
class RewardCasketAmount {
  RewardCasketAmount(this.tier, this.amount, this.unlocked);

  String tier;
  int amount;
  bool unlocked;

  factory RewardCasketAmount.fromJson(Map<String, dynamic> json) =>
      _$RewardCasketAmountFromJson(json);

  Map<String, dynamic> toJson() => _$RewardCasketAmountToJson(this);
}
