import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rstrivia/constants.dart';
import 'package:rstrivia/domain/collection_log_tier.dart';
import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/reward_casket.dart';
import 'package:rstrivia/domain/reward_casket_beginner.dart';
import 'package:rstrivia/domain/reward_casket_easy.dart';
import 'package:rstrivia/domain/reward_casket_elite.dart';
import 'package:rstrivia/domain/reward_casket_hard.dart';
import 'package:rstrivia/domain/reward_casket_master.dart';
import 'package:rstrivia/domain/reward_casket_medium.dart';
import 'package:rstrivia/domain/user_data.dart';
import 'package:rstrivia/extensions/string_extension.dart';
import 'package:rstrivia/service_locator.dart';
import 'package:rstrivia/services/user_data_service.dart';
import 'package:rstrivia/widgets/alert_dialog_close_button.dart';
import 'package:rstrivia/widgets/alert_dialog_text.dart';
import 'package:rstrivia/widgets/alert_dialog_title.dart';
import 'package:rstrivia/widgets/reward_casket_tile.dart';
import 'package:rstrivia/widgets/reward_item_tile.dart';
import 'package:rstrivia/widgets/title_text.dart';

class RewardCasketScreen extends StatefulWidget {
  static final String id = 'reward_casket_screen';

  @override
  _RewardCasketScreenState createState() => _RewardCasketScreenState();
}

class _RewardCasketScreenState extends State<RewardCasketScreen> {
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

  List<Widget> _getRewardCasketDialogWidgets(
      RewardCasket rewardCasket, List<Loot> totalLoot) {
    List<Widget> widgets = List();

    widgets.add(AlertDialogText(
      text:
          'You have completed ${numberFormatter.format(userData.getRewardCasketsOpenedByTier(rewardCasket.tier))} ${rewardCasket.tier.capitalize()} Treasure Trails.',
    ));

    widgets.add(SizedBox(height: 15.0));

    widgets.addAll(_createRewardItemTiles(totalLoot, rewardCasket.tier));

    return widgets;
  }

  _showRewardCasketDialog(RewardCasket rewardCasket, int amount) {
    _updateRewardCaskets(rewardCasket.tier, amount);
    _updateCasketsOpened(rewardCasket.tier, amount);
    List<Loot> totalLoot = _updateAcquiredLoot(rewardCasket, amount);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AlertDialogTitle(
              text: 'Reward Casket ${rewardCasket.tier}',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children:
                    _getRewardCasketDialogWidgets(rewardCasket, totalLoot),
              ),
            ),
            actions: <Widget>[
              AlertDialogCloseButton(),
            ],
          );
        });
  }

  List<Widget> _initializeContent() {
    List<Widget> widgets = List();

    widgets.add(TitleText(
      title: 'Reward Caskets',
    ));

    widgets.add(_createRewardCasketTile(kBeginnerTier, kBeginnerTier, 0.0));
    widgets.add(
        _createRewardCasketTile(kEasyTier, kBeginnerTier, kTierUnlockedAt));
    widgets
        .add(_createRewardCasketTile(kMediumTier, kEasyTier, kTierUnlockedAt));
    widgets
        .add(_createRewardCasketTile(kHardTier, kMediumTier, kTierUnlockedAt));
    widgets
        .add(_createRewardCasketTile(kEliteTier, kHardTier, kTierUnlockedAt));
    widgets
        .add(_createRewardCasketTile(kMasterTier, kEliteTier, kTierUnlockedAt));

    return widgets;
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

  Widget _createRewardCasketTile(
      String tier, String previousTier, double unlockedAt) {
    RewardCasket rewardCasket = _getRewardCasketByTier(tier);

    return RewardCasketTile(
      name: userData.getRewardCasketAmountByTier(tier).tier,
      amount: userData.getRewardCasketAmountByTier(tier).amount,
      unlocked:
          userData.getProgressByTier(previousTier) >= unlockedAt ? true : false,
      onTap: () {
        if (userData.getRewardCasketAmountByTier(tier).amount > 0) {
          _showRewardCasketDialog(rewardCasket, 1);
        }
      },
      onLongPress: () {
        if (userData.getRewardCasketAmountByTier(tier).amount >=
            userData.longPressedOpenAmount) {
          _showRewardCasketDialog(rewardCasket, userData.longPressedOpenAmount);
        }
      },
    );
  }

  RewardCasket _getRewardCasketByTier(String tier) {
    RewardCasket rewardCasket;

    if (tier == kBeginnerTier) {
      rewardCasket = RewardCasketBeginner();
    } else if (tier == kEasyTier) {
      rewardCasket = RewardCasketEasy();
    } else if (tier == kMediumTier) {
      rewardCasket = RewardCasketMedium();
    } else if (tier == kHardTier) {
      rewardCasket = RewardCasketHard();
    } else if (tier == kEliteTier) {
      rewardCasket = RewardCasketElite();
    } else if (tier == kMasterTier) {
      rewardCasket = RewardCasketMaster();
    }

    return rewardCasket;
  }

  void _updateRewardCaskets(String tier, int amount) {
    setState(() {
      userData.removeRewardCasketAmount(tier, amount);
    });
    userDataService.updateUserData(userData, currentUser.uid);
  }

  void _updateCasketsOpened(String tier, int amount) {
    for (CollectionLogTier collectionLogTier in userData.collectionLog) {
      if (collectionLogTier.tier == tier) {
        collectionLogTier.casketsOpened += amount;
        // update casketsOpened on Firestore
      }
    }
    userDataService.updateUserData(userData, currentUser.uid);
  }

  List<Loot> _updateAcquiredLoot(RewardCasket rewardCasket, int amount) {
    List<Loot> totalLoot = List();

    for (int i = 0; i < amount; i++) {
      for (Loot loot in rewardCasket.getLoot()) {
        userData.addLoot(loot);

        bool hasLoot = false;

        for (Loot acquiredLoot in totalLoot) {
          if (loot.name == acquiredLoot.name) {
            acquiredLoot.quantity += loot.quantity;
            hasLoot = true;
          }
        }

        if (!hasLoot) {
          totalLoot.add(loot);
        }
      }
    }

    userDataService.updateUserData(userData, currentUser.uid);

    return totalLoot;
  }

  bool _isSharedTierUnique(Loot loot) {
    for (Loot uniqueLoot
        in userData.getCollectionLogByTier(kSharedTier).uniques) {
      if (loot.name == uniqueLoot.name &&
          uniqueLoot.quantity - loot.quantity == 0) {
        return true;
      }
    }
    return false;
  }

  bool _isTierSpecificUnique(Loot loot, String tier) {
    for (Loot uniqueLoot in userData.getCollectionLogByTier(tier).uniques) {
      if (loot.name == uniqueLoot.name &&
          uniqueLoot.quantity - loot.quantity == 0) {
        return true;
      }
    }
    return false;
  }

  List<Widget> _createRewardItemTiles(List<Loot> totalLoot, String tier) {
    List<Widget> widgets = List();

    for (Loot loot in totalLoot) {
      bool isUnique = false;

      isUnique = _isTierSpecificUnique(loot, tier);

      if (tier != kBeginnerTier) {
        isUnique =
            _isTierSpecificUnique(loot, tier) || _isSharedTierUnique(loot);
      }

      widgets.add(RewardItemTile(
        name: loot.name,
        amount: loot.quantity,
        isUnique: isUnique,
      ));
    }

    return widgets;
  }
}
