import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rstrivia/constants.dart';
import 'package:rstrivia/domain/collection_log_tier.dart';
import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/user_data.dart';
import 'package:rstrivia/extensions/string_extension.dart';
import 'package:rstrivia/service_locator.dart';
import 'package:rstrivia/services/user_data_service.dart';
import 'package:rstrivia/widgets/alert_dialog_close_button.dart';
import 'package:rstrivia/widgets/alert_dialog_text.dart';
import 'package:rstrivia/widgets/alert_dialog_title.dart';
import 'package:rstrivia/widgets/collection_log_tile.dart';
import 'package:rstrivia/widgets/reward_item_tile.dart';
import 'package:rstrivia/widgets/title_text.dart';

class CollectionLogScreen extends StatefulWidget {
  static final String id = 'collection_log_screen';

  @override
  _CollectionLogScreenState createState() => _CollectionLogScreenState();
}

class _CollectionLogScreenState extends State<CollectionLogScreen> {
  final _auth = FirebaseAuth.instance;
  var currentUser;

  UserDataService userDataService = locator<UserDataService>();
  UserData userData;

  bool showSpinner = false;

  final numberFormatter = NumberFormat('#,##0', 'en_US');

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: userData != null ? _initializeContent() : [],
            )
          ],
        ),
      ),
    );
  }

  _getUserData() async {
    setState(() {
      showSpinner = true;
    });

    currentUser = _auth.currentUser;
    userData = await userDataService.getUserData(currentUser.uid);

    setState(() {
      showSpinner = false;
    });
  }

  List<Widget> _initializeContent() {
    List<Widget> widgets = List();

    widgets.add(TitleText(title: 'Collection Log'));
    widgets.addAll(_createCollectionLogTiles());
    widgets.add(_createTotalLootButton());

    return widgets;
  }

  List<Widget> _getCollectionLogDialogWidgets(
      CollectionLogTier collectionLogTier) {
    List<Widget> widgets = List();

    if (collectionLogTier.tier != kSharedTier) {
      widgets.add(AlertDialogText(
        text:
            'You have completed ${numberFormatter.format(collectionLogTier.casketsOpened)} ${collectionLogTier.tier.capitalize()} Treasure Trails in total.',
      ));
    } else {
      widgets.add(AlertDialogText(
        text:
            'You have completed ${numberFormatter.format(userData.getTotalSharedCluesOpened())} Shared Treasure Trails in total.',
      ));
    }

    widgets
        .addAll(_createCollectionLogRewardItemTiles(collectionLogTier.uniques));

    return widgets;
  }

  _showCollectionLogDialog(CollectionLogTier collectionLogTier) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AlertDialogTitle(
              text:
                  '${collectionLogTier.tier.capitalize()} ${collectionLogTier.acquiredUniques()}/${collectionLogTier.uniques.length}',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: _getCollectionLogDialogWidgets(collectionLogTier),
              ),
            ),
            actions: <Widget>[
              AlertDialogCloseButton(),
            ],
          );
        });
  }

  List<Widget> _getTotalLootDialogWidgets(UserData userData) {
    List<Widget> widgets = List();

    widgets.add(AlertDialogText(
      text:
          'You have completed ${numberFormatter.format(userData.getTotalCluesOpened())} Treasure Trails in total.',
    ));
    widgets.add(SizedBox(height: 15.0));

    widgets.add(AlertDialogText(
      text:
          'Total loot value: ${numberFormatter.format(userData.getTotalLootValue())} Coins',
    ));
    widgets.add(SizedBox(height: 10.0));

    if (userData.getTotalLootValue() > 0) {
      widgets.add(_createSellAllLootButton());
    }

    widgets.addAll(_createTotalLootRewardItemTiles());

    return widgets;
  }

  _showTotalLootDialog(UserData userData) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AlertDialogTitle(
              text: 'Total loot',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: _getTotalLootDialogWidgets(userData),
              ),
            ),
            actions: <Widget>[
              AlertDialogCloseButton(),
            ],
          );
        });
  }

  List<Widget> _createTotalLootRewardItemTiles() {
    List<Widget> widgets = List();

    for (Loot loot in userData.totalLoot) {
      widgets.add(RewardItemTile(
        name: loot.name,
        amount: loot.quantity,
      ));
    }

    return widgets;
  }

  Widget _createSellAllLootButton() {
    return RaisedButton.icon(
        onPressed: () {
          userData.sellTotalLoot();
          userDataService.updateUserData(userData, currentUser.uid);
          Navigator.of(context).pop();
        },
        icon: Icon(FontAwesomeIcons.dollarSign),
        label: Text(
          'Sell All Loot',
          style: TextStyle(
            fontFamily: 'Runescape',
            fontSize: 22.0,
          ),
        ));
  }

  List<Widget> _createCollectionLogRewardItemTiles(List<Loot> uniques) {
    List<Widget> widgets = List();

    for (Loot loot in uniques) {
      loot.quantity > 0
          ? widgets.add(
              RewardItemTile(
                name: loot.name,
                amount: loot.quantity,
                isUnique: true,
              ),
            )
          : widgets.add(
              RewardItemTile(
                name: loot.name,
                amount: loot.quantity,
              ),
            );
    }

    return widgets;
  }

  Widget _createTotalLootButton() {
    return GestureDetector(
      onTap: () => _showTotalLootDialog(userData),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Card(
            child: ListTile(
          leading: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: Image(
              image: AssetImage('assets/img/items/coins.png'),
              width: 50.0,
            ),
          ),
          title: Text(
            'Total loot',
            style: TextStyle(fontSize: 25.0, fontFamily: 'Runescape'),
          ),
        )),
      ),
    );
  }

  List<Widget> _createCollectionLogTiles() {
    List<Widget> widgets = List();

    for (CollectionLogTier collectionLogTier in userData.collectionLog) {
      widgets.add(CollectionLogTile(
        tier: collectionLogTier,
        onTap: () => _showCollectionLogDialog(collectionLogTier),
      ));
    }

    return widgets;
  }
}
