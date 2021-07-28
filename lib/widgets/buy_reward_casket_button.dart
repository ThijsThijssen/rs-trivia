import 'package:flutter/material.dart';
import 'package:rstrivia/widgets/alert_dialog_text.dart';

class BuyRewardCasketButton extends StatelessWidget {
  final int amount;
  final Function onPressed;
  BuyRewardCasketButton({this.amount, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      child: RaisedButton(
        onPressed: onPressed,
        child: AlertDialogText(text: '$amount'),
      ),
    );
  }
}
