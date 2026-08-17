import 'package:flutter/material.dart';

enum SkinUnlockMethod {
  free,
  levelProgress,
  rewardedAd,
  purchase,
}

/// Catalog model defining a cosmetic skin appearance and unlock conditions.
class SkinModel {
  final String id;
  final String name;
  final String description;
  final SkinUnlockMethod unlockMethod;
  final int requiredLevel; // Applicable when unlockMethod == levelProgress
  final IconData previewIcon;
  final Color accentColor;

  const SkinModel({
    required this.id,
    required this.name,
    required this.description,
    required this.unlockMethod,
    this.requiredLevel = 1,
    required this.previewIcon,
    required this.accentColor,
  });

  /// Evaluates whether this skin is unlocked given the player's highest unlocked campaign level.
  bool isUnlocked({required int highestUnlockedLevel, required bool isCampaignCompleted}) {
    switch (unlockMethod) {
      case SkinUnlockMethod.free:
        return true;
      case SkinUnlockMethod.levelProgress:
        if (requiredLevel > 100) {
          return isCampaignCompleted;
        }
        return highestUnlockedLevel >= requiredLevel;
      case SkinUnlockMethod.rewardedAd:
      case SkinUnlockMethod.purchase:
        // Reserved for future monetization phases
        return false;
    }
  }

  /// Display text explaining unlock criteria.
  String get unlockRequirementText {
    switch (unlockMethod) {
      case SkinUnlockMethod.free:
        return 'UNLOCKED';
      case SkinUnlockMethod.levelProgress:
        if (requiredLevel > 100) {
          return 'COMPLETE CAMPAIGN';
        }
        final worldNum = ((requiredLevel - 1) ~/ 10) + 1;
        return 'REACH WORLD $worldNum';
      case SkinUnlockMethod.rewardedAd:
        return 'WATCH AD (FUTURE)';
      case SkinUnlockMethod.purchase:
        return 'PREMIUM (FUTURE)';
    }
  }
}
