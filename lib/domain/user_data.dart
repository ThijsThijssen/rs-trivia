import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:rstrivia/constants.dart';
import 'package:rstrivia/domain/collection_log_tier.dart';
import 'package:rstrivia/domain/loot.dart';
import 'package:rstrivia/domain/loot_table_item.dart';
import 'package:rstrivia/domain/reward_casket_amount.dart';
import 'package:rstrivia/domain/trivia_level.dart';
import 'package:rstrivia/domain/trivia_question.dart';
import 'package:rstrivia/domain/win_streak.dart';

part 'user_data.g.dart';

@JsonSerializable(explicitToJson: true)
class UserData {
  UserData(
      this.triviaQuestions,
      this.triviaLevels,
      this.rewardCasketAmounts,
      this.collectionLog,
      this.totalLoot,
      this.winStreaks,
      this.longPressedOpenAmount,
      this.longPressedOpenAmountUnlocked,
      this.rewardCasketMultiplier);

  List<TriviaQuestion> triviaQuestions;
  List<TriviaLevel> triviaLevels;
  List<RewardCasketAmount> rewardCasketAmounts;
  List<CollectionLogTier> collectionLog;
  List<Loot> totalLoot;
  List<WinStreak> winStreaks;
  int longPressedOpenAmount;
  int longPressedOpenAmountUnlocked;
  int rewardCasketMultiplier;

  void incrementWinStreakByTier(String tier) {
    for (WinStreak winStreak in winStreaks) {
      if (winStreak.tier == tier) {
        winStreak.winStreak++;
      }
    }
  }

  void resetWinStreakByTier(String tier) {
    for (WinStreak winStreak in winStreaks) {
      if (winStreak.tier == tier) {
        winStreak.winStreak = 0;
      }
    }
  }

  int getWinStreakByTier(String tier) {
    for (WinStreak winStreak in winStreaks) {
      if (winStreak.tier == tier) {
        return winStreak.winStreak;
      }
    }

    return null;
  }

  List<TriviaQuestion> getTriviaQuestionsByTier(String tier) {
    List<TriviaQuestion> triviaQuestionsByTier = List();

    for (TriviaQuestion triviaQuestion in triviaQuestions) {
      if (triviaQuestion.tier == tier) {
        triviaQuestionsByTier.add(triviaQuestion);
      }
    }

    return triviaQuestionsByTier;
  }

  TriviaQuestion getRandomTriviaQuestionByTier(String tier) {
    List<TriviaQuestion> triviaQuestionsByTier = getTriviaQuestionsByTier(tier);

    Random r = Random();
    int low = 0;
    int high = triviaQuestionsByTier.length;
    int randomQuestion = r.nextInt(high - low) + low;

    return triviaQuestionsByTier[randomQuestion];
  }

  TriviaLevel getTriviaLevelByTier(String tier) {
    for (TriviaLevel triviaLevel in triviaLevels) {
      if (triviaLevel.tier == tier) {
        return triviaLevel;
      }
    }

    return null;
  }

  RewardCasketAmount getRewardCasketAmountByTier(String tier) {
    for (RewardCasketAmount rewardCasketAmount in rewardCasketAmounts) {
      if (rewardCasketAmount.tier == tier) {
        return rewardCasketAmount;
      }
    }

    return null;
  }

  void addRewardCasketAmount(String tier, int amount) {
    for (RewardCasketAmount rewardCasketAmount in rewardCasketAmounts) {
      if (rewardCasketAmount.tier == tier) {
        rewardCasketAmount.amount += amount;
      }
    }
  }

  void removeRewardCasketAmount(String tier, int amount) {
    for (RewardCasketAmount rewardCasketAmount in rewardCasketAmounts) {
      if (rewardCasketAmount.tier == tier) {
        rewardCasketAmount.amount -= amount;
      }
    }
  }

  int getRewardCasketsOpenedByTier(String tier) {
    int rewardCasketsOpened = 0;

    for (CollectionLogTier collectionLogTier in collectionLog) {
      if (collectionLogTier.tier == tier) {
        rewardCasketsOpened = collectionLogTier.casketsOpened;
      }
    }

    return rewardCasketsOpened;
  }

  double getProgressByTier(String tier) {
    double progress = 0.0;

    for (CollectionLogTier collectionLogTier in collectionLog) {
      if (collectionLogTier.tier == tier) {
        int totalUniques = 0;

        for (Loot loot in collectionLogTier.uniques) {
          if (loot.quantity > 0) {
            totalUniques++;
          }
        }

        if (collectionLogTier.uniques.length > 0) {
          progress = (totalUniques / collectionLogTier.uniques.length) * 100.0;
        } else {
          progress = 0.0;
        }
      }
    }

    return progress;
  }

  void addLoot(Loot lootToAdd) {
    bool isUnique = false;

    for (CollectionLogTier tier in collectionLog) {
      for (Loot loot in tier.uniques) {
        if (loot.name == lootToAdd.name) {
          loot.quantity += lootToAdd.quantity;
          isUnique = true;
        }
      }
    }

    if (!isUnique) {
      addLootToTotalLoot(lootToAdd);
    }
  }

  void addLootToTotalLoot(Loot lootToAdd) {
    bool hasLoot = false;

    for (Loot loot in totalLoot) {
      if (loot.name == lootToAdd.name) {
        loot.quantity += lootToAdd.quantity;
        hasLoot = true;
      }
    }

    if (!hasLoot) {
      totalLoot.add(lootToAdd);
    }
  }

  CollectionLogTier getCollectionLogByTier(String tier) {
    for (CollectionLogTier collectionLogTier in collectionLog) {
      if (collectionLogTier.tier == tier) {
        return collectionLogTier;
      }
    }
    return null;
  }

  int getTotalLootValue() {
    int totalValue = 0;

    for (Loot loot in totalLoot) {
      for (LootTableItem item in kTotalLootItems) {
        if (loot.name == item.name) {
          totalValue += (loot.quantity * item.price);
        }
      }
    }

    return totalValue;
  }

  void sellTotalLoot() {
    int totalValue = totalLoot.first.quantity + getTotalLootValue();

    totalLoot = [];

    totalLoot.add(Loot(
      name: 'Coins',
      quantity: totalValue,
    ));
  }

  int getTotalCluesOpened() {
    int totalCluesOpened = 0;

    for (CollectionLogTier collectionLogTier in collectionLog) {
      totalCluesOpened += collectionLogTier.casketsOpened;
    }

    return totalCluesOpened;
  }

  int getTotalSharedCluesOpened() {
    int totalSharedCluesOpened = 0;

    for (CollectionLogTier collectionLogTier in collectionLog) {
      if (collectionLogTier.tier != kBeginnerTier &&
          collectionLogTier.tier != kSharedTier) {
        totalSharedCluesOpened += collectionLogTier.casketsOpened;
      }
    }

    return totalSharedCluesOpened;
  }

  int getTotalCoins() {
    for (Loot loot in totalLoot) {
      if (loot.name == 'Coins') {
        return loot.quantity;
      }
    }

    return 0;
  }

  void removeCoinsFromTotalLoot(int amount) {
    for (Loot loot in totalLoot) {
      if (loot.name == 'Coins') {
        loot.quantity -= amount;
      }
    }
  }

  int getLongPressedOpenAmountIndex() {
    int index = 0;

    for (int i = 1; i < kLongPressedOpenAmounts.length; i++) {
      if (longPressedOpenAmountUnlocked == kLongPressedOpenAmounts[i]) {
        index = i;
      }
    }

    return index;
  }

  int getRewardCasketMultiplierIndex() {
    int index = 0;

    for (int i = 1; i < kRewardCasketMultipliers.length; i++) {
      if (rewardCasketMultiplier == kRewardCasketMultipliers[i]) {
        index = i;
      }
    }

    return index;
  }

  bool canUpgradeLongPressedOpenAmount() {
    return getLongPressedOpenAmountIndex() + 1 < kLongPressedOpenAmounts.length
        ? true
        : false;
  }

  bool canUpgradeRewardCasketMultiplier() {
    return getRewardCasketMultiplierIndex() + 1 <
            kRewardCasketMultipliers.length
        ? true
        : false;
  }

  void upgradeLongPressedOpenAmount() {
    // remove price
    removeCoinsFromTotalLoot(
        kLongPressedOpenAmountPrices[getLongPressedOpenAmountIndex() + 1]);

    // upgrade longPressedOpenAmount
    longPressedOpenAmount =
        kLongPressedOpenAmounts[getLongPressedOpenAmountIndex() + 1];

    // upgrade longPressedOpenAmountUnlocked
    longPressedOpenAmountUnlocked =
        kLongPressedOpenAmounts[getLongPressedOpenAmountIndex() + 1];
  }

  void upgradeRewardCasketMultiplier() {
    // remove price
    removeCoinsFromTotalLoot(
        kRewardCasketMultiplierPrices[getRewardCasketMultiplierIndex() + 1]);

    // upgrade longPressedOpenAmount
    rewardCasketMultiplier =
        kRewardCasketMultipliers[getRewardCasketMultiplierIndex() + 1];
  }

  void setLongPressedOpenAmount(int amount) {
    if (amount <= longPressedOpenAmountUnlocked) {
      longPressedOpenAmount = amount;
    }
  }

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
