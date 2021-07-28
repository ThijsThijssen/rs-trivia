import 'package:rstrivia/constants.dart';
import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/loot_table.dart';
import 'package:rstrivia/domain/loot_table_item.dart';
import 'package:rstrivia/domain/loot_table_table.dart';
import 'package:rstrivia/domain/reward_casket.dart';

class RewardCasketMedium extends RewardCasket {
  static final String name = 'medium';
  static final int minRewards = 3;
  static final int maxRewards = 5;

  // rare     = 1/12
  // not rare = 10/12
  // shared   = 1/12

  RewardCasketMedium() {
    super.tier = name;
    _setupLootTable();
  }

  void _setupLootTable() {
    LootTableTable uniqueTable =
        LootTableTable(name: 'Unique table', weight: 1);

    for (LootTableItem uniqueTableItem in kMediumRewardUniqueTableItems) {
      uniqueTable.addItemToTable(uniqueTableItem);
    }

    LootTableTable sharedTable =
        LootTableTable(name: 'Shared table', weight: 1);

    for (LootTableItem sharedTableItem in kSharedRewardTableItems) {
      sharedTable.addItemToTable(sharedTableItem);
    }

    LootTableTable commonTable =
        LootTableTable(name: 'Common table', weight: 10);

    for (LootTableItem commonTableItem in kMediumRewardCommonTableItems) {
      commonTable.addItemToTable(commonTableItem);
    }

    LootTable mediumClueRewards = LootTable();

    mediumClueRewards.addLootToTable(uniqueTable);
    mediumClueRewards.addLootToTable(sharedTable);
    mediumClueRewards.addLootToTable(commonTable);

    setLootTable(mediumClueRewards);
  }

  @override
  List<Loot> getLoot({int minRolls, int maxRolls}) {
    return super.getLoot(minRolls: minRewards, maxRolls: maxRewards);
  }
}
