import 'dart:math';

import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/loot_table.dart';

class RewardCasket {
  String tier;
  LootTable lootTable;

  void setLootTable(LootTable lootTable) {
    this.lootTable = lootTable;
  }

  List<Loot> getLoot({int minRolls, int maxRolls}) {
    List<Loot> totalLoot = List();

    Random r = Random();
    int nRolls = r.nextInt(maxRolls - minRolls + 1) + minRolls;

    for (int i = 0; i < nRolls; i++) {
      Loot newLoot = lootTable.calculateLoot();

      bool hasLoot = false;

      for (Loot loot in totalLoot) {
        if (loot.name == newLoot.name) {
          loot.quantity += newLoot.quantity;
          hasLoot = true;
        }
      }

      if (!hasLoot) {
        totalLoot.add(newLoot);
      }
    }

    return totalLoot;
  }
}
