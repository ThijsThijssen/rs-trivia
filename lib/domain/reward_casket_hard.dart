import 'package:rstrivia/constants.dart';
import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/loot_table.dart';
import 'package:rstrivia/domain/loot_table_item.dart';
import 'package:rstrivia/domain/loot_table_table.dart';
import 'package:rstrivia/domain/reward_casket.dart';

class RewardCasketHard extends RewardCasket {
  static final String name = 'hard';
  static final int minRewards = 4;
  static final int maxRewards = 6;

  // mega rare = 1/1625
  // rare      = 116/1625
  // not rare  = 1393/1625
  // shared    = 116/1625

  RewardCasketHard() {
    super.tier = name;
    _setupLootTable();
  }

  void _setupLootTable() {
    LootTableTable megaRareTable =
        LootTableTable(name: 'Mega rare table', weight: 1);

    for (LootTableItem megaRareTableItem in kHardRewardMegaRareTableItems) {
      megaRareTable.addItemToTable(megaRareTableItem);
    }

    LootTableTable uniqueTable =
        LootTableTable(name: 'Unique table', weight: 116);

    for (LootTableItem uniqueTableItem in kHardRewardUniqueTableItems) {
      uniqueTable.addItemToTable(uniqueTableItem);
    }

    LootTableTable sharedTable =
        LootTableTable(name: 'Shared table', weight: 116);

    for (LootTableItem sharedTableItem in kSharedRewardTableItems) {
      sharedTable.addItemToTable(sharedTableItem);
    }

    LootTableTable commonTable =
        LootTableTable(name: 'Common table', weight: 1393);

    for (LootTableItem commonTableItem in kHardRewardCommonTableItems) {
      commonTable.addItemToTable(commonTableItem);
    }

    LootTable hardClueRewards = LootTable();

    hardClueRewards.addLootToTable(megaRareTable);
    hardClueRewards.addLootToTable(uniqueTable);
    hardClueRewards.addLootToTable(sharedTable);
    hardClueRewards.addLootToTable(commonTable);

    setLootTable(hardClueRewards);
  }

  @override
  List<Loot> getLoot({int minRolls, int maxRolls}) {
    return super.getLoot(minRolls: minRewards, maxRolls: maxRewards);
  }
}
