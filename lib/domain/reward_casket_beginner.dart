import 'package:rstrivia/constants.dart';
import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/loot_table.dart';
import 'package:rstrivia/domain/loot_table_item.dart';
import 'package:rstrivia/domain/loot_table_table.dart';
import 'package:rstrivia/domain/reward_casket.dart';

class RewardCasketBeginner extends RewardCasket {
  static final String name = 'beginner';
  static final int minRewards = 1;
  static final int maxRewards = 3;

  RewardCasketBeginner() {
    super.tier = name;
    _setupLootTable();
  }

  void _setupLootTable() {
    LootTableTable uniqueTable =
        LootTableTable(name: 'Unique table', weight: 21);

    for (LootTableItem uniqueTableItem in kBeginnerRewardUniqueTableItems) {
      uniqueTable.addItemToTable(uniqueTableItem);
    }

    LootTableItem cabbage = LootTableItem.quantity(
        name: 'Cabbage', weight: 21, quantityMin: 5, quantityMax: 9);

    LootTableTable blackTable = LootTableTable(name: 'Black table', weight: 11);

    for (LootTableItem blackTableItem in kBeginnerRewardBlackTableItems) {
      blackTable.addItemToTable(blackTableItem);
    }

    LootTableTable commonItemTable =
        LootTableTable(name: 'Common item table', weight: 440);

    for (LootTableItem commonTableItem in kBeginnerRewardCommonTableItems) {
      commonItemTable.addItemToTable(commonTableItem);
    }

    LootTable beginnerClueRewards = LootTable();

    beginnerClueRewards.addLootToTable(uniqueTable);
    beginnerClueRewards.addLootToTable(cabbage);
    beginnerClueRewards.addLootToTable(blackTable);
    beginnerClueRewards.addLootToTable(commonItemTable);

    setLootTable(beginnerClueRewards);
  }

  @override
  List<Loot> getLoot({int minRolls, int maxRolls}) {
    return super.getLoot(minRolls: minRewards, maxRolls: maxRewards);
  }
}
