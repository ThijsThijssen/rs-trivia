import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rstrivia/extensions/string_extension.dart';

class PowerUpTile extends StatefulWidget {
  final String name;
  final int cost;
  final int amount;
  final bool canBuy;
  final Function onTap;
  final IconData icon;
  final String information;

  PowerUpTile(
      {this.name,
      this.cost,
      this.amount,
      this.canBuy,
      this.onTap,
      this.icon,
      this.information});

  @override
  _PowerUpTileState createState() => _PowerUpTileState();
}

class _PowerUpTileState extends State<PowerUpTile> {
  GlobalKey _toolTipKey = GlobalKey();

  _showSnackBar() {
    final snackBar = SnackBar(
      content: Text('You do not have enough money to buy this power up.'),
      duration: Duration(
        seconds: 1,
        milliseconds: 500,
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  var numberFormatter = NumberFormat('#,##0', 'en_US');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.canBuy ? widget.onTap : _showSnackBar,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Card(
          child: ListTile(
            leading: Icon(
              widget.icon,
              size: 40,
            ),
            title: Text(
              '${widget.name.capitalize()} (${widget.amount})',
              style: TextStyle(
                fontFamily: 'Runescape',
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(
              'Price: ${numberFormatter.format(widget.cost)} Coins',
              style: TextStyle(
                fontFamily: 'Runescape',
                fontSize: 18.0,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                final dynamic tooltip = _toolTipKey.currentState;
                tooltip.ensureTooltipVisible();
              },
              child: Tooltip(
                key: _toolTipKey,
                message: '${widget.information}',
                child: Icon(FontAwesomeIcons.info),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
