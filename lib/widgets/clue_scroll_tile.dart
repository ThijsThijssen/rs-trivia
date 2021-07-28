import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../extensions/string_extension.dart';

class ClueScrollTile extends StatefulWidget {
  final String name;
  final double progress;
  final bool unlocked;
  final Function onTap;

  ClueScrollTile({this.name, this.progress, this.unlocked, this.onTap});

  @override
  _ClueScrollTileState createState() => _ClueScrollTileState();
}

class _ClueScrollTileState extends State<ClueScrollTile> {
  GlobalKey _toolTipKey = GlobalKey();

  _showSnackBar() {
    final snackBar = SnackBar(
      content: Text('${widget.name.capitalize()} Clue Scrolls are locked.'),
      duration: Duration(
        seconds: 1,
        milliseconds: 500,
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.unlocked ? widget.onTap : _showSnackBar,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Card(
          child: ListTile(
            leading: Image(
              image:
                  AssetImage('assets/img/misc/clue_scroll_${widget.name}.png'),
            ),
            title: Text(
              '${widget.name.capitalize()} Clue Scroll',
              style: TextStyle(fontFamily: 'Runescape', fontSize: 20.0),
            ),
            subtitle: Text(
              'Progress: ${widget.progress.toStringAsFixed(2)}%',
              style: TextStyle(fontFamily: 'Runescape', fontSize: 18.0),
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
