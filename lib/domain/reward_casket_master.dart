import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/reward_casket.dart';

class RewardCasketMaster extends RewardCasket {
  static final String name = 'master';
  static final int minRewards = 5;
  static final int maxRewards = 7;

  // bloodhound pet = 1/1000
  // mega rare      = 2/1000
  // rare           = 42/1000
  // not rare       = 924/1000
  // shared         = 42/1000

  RewardCasketMaster() {
    super.tier = name;
    _setupLootTable();
  }

  void _setupLootTable() {}

  @override
  List<Loot> getLoot({int minRolls, int maxRolls}) {
    return super.getLoot(minRolls: minRewards, maxRolls: maxRewards);
  }
}
