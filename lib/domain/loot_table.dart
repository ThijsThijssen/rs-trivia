import 'dart:math';

import 'package:rstrivia/domain/loot.dart';

class LootTable {
  String name;
  int weight;
  List<LootTable> lootTableList;

  LootTable() {
    lootTableList = List();
  }

  void addLootToTable(LootTable lootToAdd) {
    this.lootTableList.add(lootToAdd);
  }

  Loot calculateLoot() {
    int sum = 0;

    for (LootTable table in lootTableList) {
      sum += table.weight;
    }

    int number = getRandomNumberInclusive(1, sum);
    int prevRange = 1;
    int range = 0;

    for (LootTable table in lootTableList) {
      range += table.weight;
      if (number >= prevRange && number <= range) {
        return table.getLoot();
      }

      prevRange = range;
    }

    return null;
  }

  int getRandomNumberInclusive(int min, int max) {
    Random r = Random();
    return r.nextInt(max + 1 - min) + min;
  }

  int getRandomNumberExclusive(int min, int max) {
    Random r = Random();
    return r.nextInt(max - min) + min;
  }

  Loot getLoot() {
    return null;
  }
}
