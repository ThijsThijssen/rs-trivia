import 'package:flutter/cupertino.dart';

import 'loot.dart';
import 'loot_table.dart';

class LootTableItem extends LootTable {
  int quantity;
  int price;

  LootTableItem({@required String name, @required int weight, int price = 1}) {
    super.name = name;
    super.weight = weight;
    this.quantity = 1;
    this.price = price;
  }

  LootTableItem.quantity(
      {@required String name,
      @required int weight,
      @required int quantityMin,
      @required int quantityMax,
      int price}) {
    super.name = name;
    super.weight = weight;
    this.quantity = calculateQuantity(quantityMin, quantityMax);
    this.price = price;
  }

  int calculateQuantity(int quantityMin, int quantityMax) {
    return getRandomNumberInclusive(quantityMin, quantityMax);
  }

  @override
  Loot getLoot() {
    return Loot(name: name, quantity: quantity);
  }
}
