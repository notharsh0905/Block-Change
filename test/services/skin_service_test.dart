import 'package:flutter_test/flutter_test.dart';
import 'package:block_change/models/skin_model.dart';
import 'package:block_change/services/progress_service.dart';
import 'package:block_change/services/settings_service.dart';
import 'package:block_change/services/skin_service.dart';

void main() {
  group('SkinService & SkinModel Tests', () {
    late InMemoryProgressStorage storage;
    late SettingsService settingsService;
    late ProgressService progressService;
    late SkinService skinService;

    setUp(() async {
      storage = InMemoryProgressStorage();
      settingsService = SettingsService.withStorage(storage);
      await settingsService.initialize();

      ProgressService.resetInstanceForTesting(storage);
      progressService = ProgressService.instance;
      await progressService.loadProgress();

      SettingsService.resetInstanceForTesting(testInstance: settingsService);
      skinService = SkinService.instance;
    });

    test('1. Classic skin is unlocked and equipped by default', () {
      final skin = skinService.equippedSkin;
      expect(skin.id, equals('classic'));
      expect(skinService.isSkinUnlocked(skin), isTrue);
    });

    test('2. Rainbow skin unlocks at World 2 completion (Level 21)', () async {
      final rainbowSkin = skinService.getSkinById('rainbow');

      // Default level = 1 -> Locked
      expect(skinService.isSkinUnlocked(rainbowSkin), isFalse);

      // Unlock up to level 21
      await progressService.recordLevelCompletion(
        levelId: 20,
        stars: 3,
        score: 1000,
        moves: 5,
        timeRemainingSeconds: 30,
      );

      expect(progressService.currentProgress.highestUnlockedLevel, equals(21));
      expect(skinService.isSkinUnlocked(rainbowSkin), isTrue);
    });

    test('3. Equipping unlocked skin updates equippedSkin and persists', () async {
      final rainbowSkin = skinService.getSkinById('rainbow');
      await progressService.recordLevelCompletion(
        levelId: 20,
        stars: 3,
        score: 1000,
        moves: 5,
        timeRemainingSeconds: 30,
      );

      final success = await skinService.equipSkin(rainbowSkin);
      expect(success, isTrue);
      expect(skinService.equippedSkin.id, equals('rainbow'));
      expect(settingsService.currentSettings.selectedSkinId, equals('rainbow'));
    });

    test('4. Cannot equip locked skin', () async {
      final fireSkin = skinService.getSkinById('fire');
      final success = await skinService.equipSkin(fireSkin);
      expect(success, isFalse);
      expect(skinService.equippedSkin.id, equals('classic'));
    });

    test('5. Future ad/purchase skins remain locked in Phase 5', () {
      final catSkin = skinService.getSkinById('cute_cats');
      expect(catSkin.unlockMethod, equals(SkinUnlockMethod.rewardedAd));
      expect(skinService.isSkinUnlocked(catSkin), isFalse);
    });
  });
}
