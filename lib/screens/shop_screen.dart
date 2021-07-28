import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rstrivia/constants.dart';
import 'package:rstrivia/domain/user_data.dart';
import 'package:rstrivia/extensions/string_extension.dart';
import 'package:rstrivia/service_locator.dart';
import 'package:rstrivia/services/user_data_service.dart';
import 'package:rstrivia/widgets/alert_dialog_close_button.dart';
import 'package:rstrivia/widgets/alert_dialog_text.dart';
import 'package:rstrivia/widgets/alert_dialog_title.dart';
import 'package:rstrivia/widgets/buy_reward_casket_button.dart';
import 'package:rstrivia/widgets/power_up_tile.dart';
import 'package:rstrivia/widgets/reward_casket_tile.dart';
import 'package:rstrivia/widgets/title_text.dart';

class ShopScreen extends StatefulWidget {
  static final String id = 'shop_screen';

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: userData != null ? _initializeContent() : [],
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

    widgets.add(TitleText(title: 'Shop'));

    widgets.add(_createTotalCoins());

    widgets.add(Expanded(
      child: ListView(
        children: [
          Column(
            children: _createShopContents(),
          )
        ],
      ),
    ));

    return widgets;
  }

  Widget _createTotalCoins() {
    int totalCoins = userData.getTotalCoins();

    return Text(
      '${numberFormatter.format(totalCoins)} Coins',
      style: TextStyle(
        fontFamily: 'Runescape',
        fontSize: 30.0,
      ),
    );
  }

  _showBuyRewardCasketDialog(String tier) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AlertDialogTitle(
              text: 'Reward Casket ${tier.capitalize()}',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: _getBuyRewardCasketDialogWidgets(tier),
              ),
            ),
            actions: <Widget>[
              AlertDialogCloseButton(),
            ],
          );
        });
  }

  List<Widget> _getBuyRewardCasketDialogWidgets(String tier) {
    List<Widget> widgets = List();

    widgets.add(AlertDialogText(
      text:
          'You currently have: \n${numberFormatter.format(userData.getTotalCoins())} Coins.',
    ));

    widgets.add(SizedBox(height: 15.0));

    widgets.add(AlertDialogText(
      text:
          'A Reward Casket ${tier.capitalize()} costs: \n${numberFormatter.format(_getCasketPriceByTier(tier))} Coins.',
    ));

    widgets.add(SizedBox(height: 15.0));

    widgets.add(AlertDialogText(
      text: 'How many would you like to buy?',
    ));

    widgets.add(SizedBox(height: 15.0));

    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _createBuyCasketButtons(tier),
    ));

    return widgets;
  }

  int _getCasketPriceByTier(String tier) {
    int casketPrice = 0;

    if (tier == kBeginnerTier) {
      casketPrice = kPriceRewardCasketBeginner;
    } else if (tier == kEasyTier) {
      casketPrice = kPriceRewardCasketEasy;
    } else if (tier == kMediumTier) {
      casketPrice = kPriceRewardCasketMedium;
    } else if (tier == kHardTier) {
      casketPrice = kPriceRewardCasketHard;
    } else if (tier == kEliteTier) {
      casketPrice = kPriceRewardCasketElite;
    } else if (tier == kMasterTier) {
      casketPrice = kPriceRewardCasketMaster;
    }

    return casketPrice;
  }

  List<Widget> _createBuyCasketButtons(String tier) {
    List<Widget> widgets = List();
    List<int> amounts = [1, 10, 50];

    for (int amount in amounts) {
      widgets.add(BuyRewardCasketButton(
        amount: amount,
        onPressed:
            userData.getTotalCoins() >= (amount * _getCasketPriceByTier(tier))
                ? () => _buyRewardCasket(tier, amount)
                : null,
      ));
    }

    return widgets;
  }

  _buyRewardCasket(String tier, int amount) {
    // calculate price && remove coins
    setState(() {
      userData.removeCoinsFromTotalLoot(_getCasketPriceByTier(tier) * amount);
    });

    // add reward caskets
    userData.addRewardCasketAmount(tier, amount);

    // update userdata
    userDataService.updateUserData(userData, currentUser.uid);

    // pop navigator
    Navigator.of(context).pop();
  }

  Widget _createBuyRewardCasketTile(
      String tier, String previousTier, double unlockedAt) {
    return RewardCasketTile(
      name: tier,
      amount: _getCasketPriceByTier(tier),
      shopTile: true,
      unlocked:
          userData.getProgressByTier(previousTier) >= unlockedAt ? true : false,
      onTap: () {
        _showBuyRewardCasketDialog(tier);
      },
    );
  }

  List<Widget> _createShopContents() {
    List<Widget> widgets = List();

    widgets.add(SizedBox(height: 15.0));
    widgets.addAll(_createBuyRewardCasketTiles());

    widgets.add(SizedBox(height: 15.0));
    widgets.addAll(_createBuyPowerUpTiles());

    return widgets;
  }

  List<Widget> _createBuyRewardCasketTiles() {
    List<Widget> widgets = List();

    widgets.add(Text(
      'Reward Caskets',
      style: TextStyle(
        fontFamily: 'Runescape',
        fontSize: 25.0,
      ),
    ));

    widgets.add(_createBuyRewardCasketTile(kBeginnerTier, kBeginnerTier, 0.0));
    widgets.add(
        _createBuyRewardCasketTile(kEasyTier, kBeginnerTier, kTierUnlockedAt));
    widgets.add(
        _createBuyRewardCasketTile(kMediumTier, kEasyTier, kTierUnlockedAt));
    widgets.add(
        _createBuyRewardCasketTile(kHardTier, kMediumTier, kTierUnlockedAt));
    widgets.add(
        _createBuyRewardCasketTile(kEliteTier, kHardTier, kTierUnlockedAt));
    widgets.add(
        _createBuyRewardCasketTile(kMasterTier, kHardTier, kTierUnlockedAt));

    return widgets;
  }

  List<Widget> _createBuyPowerUpTiles() {
    List<Widget> widgets = List();

    widgets.add(Text(
      'Power Ups',
      style: TextStyle(
        fontFamily: 'Runescape',
        fontSize: 25.0,
      ),
    ));

    if (userData.canUpgradeLongPressedOpenAmount()) {
      widgets.add(_createLongPressedOpenAmountPowerUpTile());
    }

    if (userData.canUpgradeRewardCasketMultiplier()) {
      widgets.add(_createRewardCasketMultiplierPowerUpTile());
    }

    widgets.addAll(_createLongPressedOpenAmountPowerUpInformation());
    widgets.add(_createRewardCasketMultiplierPowerUpInformation());

    return widgets;
  }

  Widget _createLongPressedOpenAmountPowerUpTile() {
    return PowerUpTile(
      name: 'Long Pressed Open Amount',
      cost: kLongPressedOpenAmountPrices[
          userData.getLongPressedOpenAmountIndex() + 1],
      icon: FontAwesomeIcons.handPointDown,
      amount:
          kLongPressedOpenAmounts[userData.getLongPressedOpenAmountIndex() + 1],
      canBuy: userData.getTotalCoins() >
          kLongPressedOpenAmountPrices[
              userData.getLongPressedOpenAmountIndex() + 1],
      onTap: () {
        setState(() {
          userData.upgradeLongPressedOpenAmount();
          userDataService.updateUserData(userData, currentUser.uid);
        });
      },
      information: 'Press and hold a reward casket to open multiple.',
    );
  }

  List<Widget> _createLongPressedOpenAmountPowerUpInformation() {
    List<Widget> widgets = List();

    widgets.add(_createLongPressedOpenAmountInformation());
    widgets.add(_createLongPressedOpenAmountButtons());

    return widgets;
  }

  Widget _createRewardCasketMultiplierPowerUpInformation() {
    String rewardCasketMultiplierString;

    userData.rewardCasketMultiplier > 1
        ? rewardCasketMultiplierString =
            'This means you get ${userData.rewardCasketMultiplier} times more reward caskets when you answer a Trivia Question correctly.'
        : rewardCasketMultiplierString =
            'Buy the "Reward Casket Multiplier" power up to upgrade this amount.';

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      child: AlertDialogText(
        text:
            'Your current Reward Casket Multiplier is ${userData.rewardCasketMultiplier}. $rewardCasketMultiplierString',
      ),
    );
  }

  Widget _createLongPressedOpenAmountButtons() {
    List<Widget> widgets = List();

    for (int i = 1; i < userData.getLongPressedOpenAmountIndex() + 1; i++) {
      widgets.add(
        Container(
          width: 60.0,
          child: RaisedButton(
            onPressed: () {
              setState(() {
                userData.setLongPressedOpenAmount(kLongPressedOpenAmounts[i]);
                userDataService.updateUserData(userData, currentUser.uid);
              });
            },
            child: AlertDialogText(
              text: kLongPressedOpenAmounts[i].toString(),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }

  Widget _createLongPressedOpenAmountInformation() {
    String longPressedString;

    userData.longPressedOpenAmountUnlocked > 1
        ? longPressedString = 'Click the buttons below to edit this amount.'
        : longPressedString =
            'Buy the "Long Pressed Open Amount" power up to upgrade this amount.';

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      child: AlertDialogText(
        text:
            'You currently open ${userData.longPressedOpenAmount} reward caskets at once when you long press a reward casket. $longPressedString',
      ),
    );
  }

  Widget _createRewardCasketMultiplierPowerUpTile() {
    return PowerUpTile(
      name: 'Reward Casket Multiplier',
      cost: kRewardCasketMultiplierPrices[
          userData.getRewardCasketMultiplierIndex() + 1],
      icon: FontAwesomeIcons.briefcaseMedical,
      amount: kRewardCasketMultipliers[
          userData.getRewardCasketMultiplierIndex() + 1],
      canBuy: userData.getTotalCoins() >
          kRewardCasketMultiplierPrices[
              userData.getRewardCasketMultiplierIndex() + 1],
      onTap: () {
        setState(() {
          userData.upgradeRewardCasketMultiplier();
          userDataService.updateUserData(userData, currentUser.uid);
        });
      },
      information: 'Multiplier of reward caskets received.',
    );
  }
}
