import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rstrivia/domain/collection_log_tier.dart';
import 'package:rstrivia/extensions/string_extension.dart';

class CollectionLogTile extends StatefulWidget {
  CollectionLogTile({this.tier, this.onTap});

  final CollectionLogTier tier;
  final Function onTap;

  @override
  _CollectionLogTileState createState() => _CollectionLogTileState();
}

class _CollectionLogTileState extends State<CollectionLogTile> {
  final numberFormatter = NumberFormat('#,##0', 'en_US');

  _getTitle() {
    return !widget.tier.tier.contains('shared')
        ? Text(
            '${widget.tier.tier.capitalize()} ${widget.tier.acquiredUniques()}/${widget.tier.uniques.length} (${numberFormatter.format(widget.tier.casketsOpened)})',
            style: TextStyle(fontSize: 25.0, fontFamily: 'Runescape'))
        : Text(
            '${widget.tier.tier.capitalize()} ${widget.tier.acquiredUniques()}/${widget.tier.uniques.length}',
            style: TextStyle(fontSize: 25.0, fontFamily: 'Runescape'));
  }

  _isCompleted() {
    return widget.tier.acquiredUniques() == widget.tier.uniques.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Card(
            color: _isCompleted() ? Colors.greenAccent : Colors.white,
            child: ListTile(
              leading: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Image(
                  image: AssetImage(
                      'assets/img/misc/clue_scroll_${widget.tier.tier}.png'),
                  width: 50.0,
                ),
              ),
              title: _getTitle(),
            ),
          )),
    );
  }
}
