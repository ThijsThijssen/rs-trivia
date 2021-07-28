import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rstrivia/extensions/string_extension.dart';

class RewardItemTile extends StatelessWidget {
  final String name;
  final int amount;
  final bool isUnique;

  RewardItemTile({this.name, this.amount, this.isUnique = false});

  final numberFormatter = NumberFormat('#,##0', 'en_US');

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isUnique ? Colors.greenAccent : Colors.white,
      child: ListTile(
        leading: Image(
          image: AssetImage('assets/img/items/${name.toSnakeCase()}.png'),
          width: 50.0,
        ),
        title: Text(
          '${name.capitalize()}',
          style: TextStyle(fontFamily: 'Runescape', fontSize: 20.0),
        ),
        subtitle: Text(
          'Amount: ${numberFormatter.format(amount)}',
          style: TextStyle(fontFamily: 'Runescape', fontSize: 18.0),
        ),
      ),
    );
  }
}
