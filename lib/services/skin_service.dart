import 'package:flutter/material.dart';

import '../models/skin_model.dart';
import 'progress_service.dart';
import 'settings_service.dart';

/// Centralized catalog and equipment service for cosmetic tile skins.
class SkinService {
  static SkinService? _instance;
  static SkinService get instance => _instance ??= SkinService._();

  final SettingsService? _overrideSettingsService;
  final ProgressService? _overrideProgressService;

  SkinService._({
    SettingsService? settingsService,
    ProgressService? progressService,
  }) : _overrideSettingsService = settingsService,
       _overrideProgressService = progressService;

  SettingsService get _settingsService =>
      _overrideSettingsService ?? SettingsService.instance;

  ProgressService get _progressService =>
      _overrideProgressService ?? ProgressService.instance;

  @visibleForTesting
  static void resetInstanceForTesting({SkinService? testInstance}) {
    _instance = testInstance;
  }

  /// All 10 defined skins in the cosmetic catalog.
  static const List<SkinModel> allSkins = [
    SkinModel(
      id: 'classic',
      name: 'Classic Blocks',
      description: 'Sleek, vibrant geometry with crisp modern contrast.',
      unlockMethod: SkinUnlockMethod.free,
      previewIcon: Icons.widgets_rounded,
      accentColor: Color(0xFF3A86FF),
    ),
    SkinModel(
      id: 'cute_cats',
      name: 'Cute Cats',
      description: 'Playful feline whiskers and adorable paw motifs.',
      unlockMethod: SkinUnlockMethod.rewardedAd,
      previewIcon: Icons.pets_rounded,
      accentColor: Color(0xFFFF007F),
    ),
    SkinModel(
      id: 'puppies',
      name: 'Puppies',
      description: 'Cheerful puppy dog paws and happy wagging energy.',
      unlockMethod: SkinUnlockMethod.rewardedAd,
      previewIcon: Icons.pets_rounded,
      accentColor: Color(0xFFFFBE0B),
    ),
    SkinModel(
      id: 'fruits',
      name: 'Fruits',
      description:
          'Fresh citrus slices, juicy berries and sweet tropical vibes.',
      unlockMethod: SkinUnlockMethod.rewardedAd,
      previewIcon: Icons.apple_rounded,
      accentColor: Color(0xFFFB5607),
    ),
    SkinModel(
      id: 'desserts',
      name: 'Desserts',
      description: 'Sweet frosted cupcakes, donuts and sugary delights.',
      unlockMethod: SkinUnlockMethod.rewardedAd,
      previewIcon: Icons.cake_rounded,
      accentColor: Color(0xFFFF9EAE),
    ),
    SkinModel(
      id: 'rainbow',
      name: 'Rainbow',
      description: 'Luminous spectral gradients with radiant prism sheen.',
      unlockMethod: SkinUnlockMethod.levelProgress,
      requiredLevel: 21, // Unlock World 2 complete
      previewIcon: Icons.looks_rounded,
      accentColor: Color(0xFF8338EC),
    ),
    SkinModel(
      id: 'space',
      name: 'Space',
      description: 'Cosmic stellar constellations and deep galaxy nebulae.',
      unlockMethod: SkinUnlockMethod.levelProgress,
      requiredLevel: 41, // Unlock World 4 complete
      previewIcon: Icons.auto_awesome_rounded,
      accentColor: Color(0xFF7209B7),
    ),
    SkinModel(
      id: 'kawaii',
      name: 'Kawaii',
      description:
          'Charming smileys, sparkles and Japanese pop cute aesthetic.',
      unlockMethod: SkinUnlockMethod.levelProgress,
      requiredLevel: 61, // Unlock World 6 complete
      previewIcon: Icons.mood_rounded,
      accentColor: Color(0xFFFF70A6),
    ),
    SkinModel(
      id: 'ice',
      name: 'Ice',
      description:
          'Crystalline frost patterns and glacial diamond reflections.',
      unlockMethod: SkinUnlockMethod.levelProgress,
      requiredLevel: 81, // Unlock World 8 complete
      previewIcon: Icons.ac_unit_rounded,
      accentColor: Color(0xFF00F5D4),
    ),
    SkinModel(
      id: 'fire',
      name: 'Fire',
      description: 'Blazing flame embers and infernal molten glow.',
      unlockMethod: SkinUnlockMethod.levelProgress,
      requiredLevel: 101, // Unlock Campaign Completion
      previewIcon: Icons.local_fire_department_rounded,
      accentColor: Color(0xFFFF4800),
    ),
  ];

  /// Gets a skin definition by ID. Defaults to Classic if not found.
  SkinModel getSkinById(String id) {
    return allSkins.firstWhere((s) => s.id == id, orElse: () => allSkins.first);
  }

  /// Currently equipped skin.
  SkinModel get equippedSkin {
    final selectedId = _settingsService.currentSettings.selectedSkinId;
    return getSkinById(selectedId);
  }

  /// Evaluates whether a specific skin is unlocked for the current player.
  bool isSkinUnlocked(SkinModel skin) {
    final progress = _progressService.currentProgress;
    return skin.isUnlocked(
      highestUnlockedLevel: progress.highestUnlockedLevel,
      isCampaignCompleted: progress.isCampaignCompleted,
    );
  }

  /// Equips a skin if unlocked. Returns true if equip succeeded.
  Future<bool> equipSkin(SkinModel skin) async {
    if (!isSkinUnlocked(skin)) return false;
    await _settingsService.update(selectedSkinId: skin.id);
    return true;
  }
}
