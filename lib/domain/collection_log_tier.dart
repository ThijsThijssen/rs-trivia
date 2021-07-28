import 'package:json_annotation/json_annotation.dart';

import 'loot.dart';

part 'collection_log_tier.g.dart';

@JsonSerializable(explicitToJson: true)
class CollectionLogTier {
  CollectionLogTier(this.tier, this.casketsOpened, this.uniques);

  String tier;
  int casketsOpened;
  List<Loot> uniques;

  int acquiredUniques() {
    int acquired = 0;

    for (Loot loot in uniques) {
      if (loot.quantity > 0) {
        acquired++;
      }
    }

    return acquired;
  }

  factory CollectionLogTier.fromJson(Map<String, dynamic> json) =>
      _$CollectionLogTierFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionLogTierToJson(this);
}
