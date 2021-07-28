import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/reward_casket.dart';

class RewardCasketElite extends RewardCasket {
  static final String name = 'elite';
  static final int minRewards = 4;
  static final int maxRewards = 6;

  // mega rare = 1/1250
  // rare      = 48/1250
  // not rare  = 1154/1250
  // shared    = 48/1250

  RewardCasketElite() {
    super.tier = name;
    _setupLootTable();
  }

  void _setupLootTable() {}

  @override
  List<Loot> getLoot({int minRolls, int maxRolls}) {
    return super.getLoot(minRolls: minRewards, maxRolls: maxRewards);
  }
}
