import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/loot_table.dart';
import 'package:rstrivia/domain/loot_table_item.dart';

class LootTableTable extends LootTable {
  List<LootTableItem> lootTableItems;

  LootTableTable({String name, int weight}) {
    super.name = name;
    super.weight = weight;
    lootTableItems = List();
  }

  void addItemToTable(LootTableItem itemToAdd) {
    this.lootTableItems.add(itemToAdd);
  }

  @override
  Loot getLoot() {
    int number = getRandomNumberExclusive(0, lootTableItems.length);
    return Loot(
        name: lootTableItems[number].name,
        quantity: lootTableItems[number].quantity);
  }
}
