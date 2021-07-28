import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../extensions/string_extension.dart';

class RewardCasketTile extends StatefulWidget {
  final String name;
  final int amount;
  final bool unlocked;
  final Function onTap;
  final Function onLongPress;
  final bool shopTile;

  RewardCasketTile(
      {this.name,
      this.amount,
      this.unlocked,
      this.onTap,
      this.onLongPress,
      this.shopTile = false});

  @override
  _RewardCasketTileState createState() => _RewardCasketTileState();
}

class _RewardCasketTileState extends State<RewardCasketTile> {
  GlobalKey _toolTipKey = GlobalKey();

  _showSnackBar() {
    final snackBar = SnackBar(
      content: Text('${widget.name.capitalize()} Reward Caskets are locked.'),
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
      onTap: widget.unlocked ? widget.onTap : _showSnackBar,
      onLongPress: widget.unlocked ? widget.onLongPress : _showSnackBar,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Card(
          child: ListTile(
            leading: Image(
              image: AssetImage(
                  'assets/img/misc/reward_casket_${widget.name}.png'),
            ),
            title: Text(
              'Reward Casket ${widget.name.capitalize()}',
              style: TextStyle(
                fontFamily: 'Runescape',
                fontSize: 20.0,
              ),
            ),
            subtitle: widget.shopTile
                ? Text(
                    'Price: ${numberFormatter.format(widget.amount)} Coins',
                    style: TextStyle(
                      fontFamily: 'Runescape',
                      fontSize: 18.0,
                    ),
                  )
                : Text(
                    'Amount: ${numberFormatter.format(widget.amount)}',
                    style: TextStyle(
                      fontFamily: 'Runescape',
                      fontSize: 18.0,
                    ),
                  ),
            trailing: widget.unlocked
                ? GestureDetector(
                    onTap: () {
                      final dynamic tooltip = _toolTipKey.currentState;
                      tooltip.ensureTooltipVisible();
                    },
                    child: Tooltip(
                      key: _toolTipKey,
                      message: 'Unlocked.',
                      child: Icon(FontAwesomeIcons.check),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      final dynamic tooltip = _toolTipKey.currentState;
                      tooltip.ensureTooltipVisible();
                    },
                    child: Tooltip(
                      key: _toolTipKey,
                      message:
                          'Unlocked after 50.0% completion of previous tier.',
                      child: Icon(FontAwesomeIcons.lock),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
