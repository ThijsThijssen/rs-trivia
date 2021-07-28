import 'package:rstrivia/constants.dart';
import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/loot_table.dart';
import 'package:rstrivia/domain/loot_table_item.dart';
import 'package:rstrivia/domain/loot_table_table.dart';
import 'package:rstrivia/domain/reward_casket.dart';

class RewardCasketEasy extends RewardCasket {
  static final String name = 'easy';
  static final int minRewards = 2;
  static final int maxRewards = 4;

  RewardCasketEasy() {
    super.tier = name;
    _setupLootTable();
  }

  void _setupLootTable() {
    LootTableTable uniqueTable =
        LootTableTable(name: 'Unique table', weight: 1);

    for (LootTableItem uniqueTableItem in kEasyRewardUniqueTableItems) {
      uniqueTable.addItemToTable(uniqueTableItem);
    }

    LootTableTable sharedTable =
        LootTableTable(name: 'Shared table', weight: 1);

    for (LootTableItem sharedTableItem in kSharedRewardTableItems) {
      sharedTable.addItemToTable(sharedTableItem);
    }

    LootTableTable commonTable =
        LootTableTable(name: 'Common table', weight: 11);

    for (LootTableItem commonTableItem in kEasyRewardCommonTableItems) {
      commonTable.addItemToTable(commonTableItem);
    }

    LootTable easyClueRewards = LootTable();

    easyClueRewards.addLootToTable(uniqueTable);
    easyClueRewards.addLootToTable(sharedTable);
    easyClueRewards.addLootToTable(commonTable);

    setLootTable(easyClueRewards);
  }

  @override
  List<Loot> getLoot({int minRolls, int maxRolls}) {
    return super.getLoot(minRolls: minRewards, maxRolls: maxRewards);
  }
}
