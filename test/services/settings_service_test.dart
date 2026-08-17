import 'package:flutter_test/flutter_test.dart';
import 'package:block_change/models/game_settings_model.dart';
import 'package:block_change/services/progress_service.dart';
import 'package:block_change/services/settings_service.dart';

void main() {
  group('SettingsService & GameSettingsModel Tests', () {
    late InMemoryProgressStorage storage;
    late SettingsService settingsService;

    setUp(() async {
      storage = InMemoryProgressStorage();
      settingsService = SettingsService.withStorage(storage);
      await settingsService.initialize();
    });

    test('1. Default settings match PRD specification', () {
      final s = settingsService.currentSettings;
      expect(s.musicEnabled, isTrue);
      expect(s.musicVolume, equals(0.7));
      expect(s.sfxEnabled, isTrue);
      expect(s.sfxVolume, equals(0.85));
      expect(s.hapticsEnabled, isTrue);
      expect(s.hapticIntensity, equals(HapticIntensity.medium));
      expect(s.showTutorial, isTrue);
      expect(s.reducedMotion, isFalse);
      expect(s.selectedSkinId, equals('classic'));
      expect(s.selectedThemeId, equals('classic_dark'));
    });

    test('2. Updating settings persists values cleanly', () async {
      await settingsService.update(
        musicEnabled: false,
        musicVolume: 0.4,
        sfxEnabled: false,
        sfxVolume: 0.9,
        hapticsEnabled: false,
        hapticIntensity: HapticIntensity.high,
        reducedMotion: true,
        selectedSkinId: 'rainbow',
        selectedThemeId: 'ocean',
      );

      final s = settingsService.currentSettings;
      expect(s.musicEnabled, isFalse);
      expect(s.musicVolume, equals(0.4));
      expect(s.sfxEnabled, isFalse);
      expect(s.sfxVolume, equals(0.9));
      expect(s.hapticsEnabled, isFalse);
      expect(s.hapticIntensity, equals(HapticIntensity.high));
      expect(s.reducedMotion, isTrue);
      expect(s.selectedSkinId, equals('rainbow'));
      expect(s.selectedThemeId, equals('ocean'));
    });

    test('3. Settings survive service recreation from storage', () async {
      await settingsService.update(
        musicVolume: 0.2,
        sfxVolume: 0.5,
        selectedThemeId: 'sunset',
      );

      // Recreate service using same storage
      final newService = SettingsService.withStorage(storage);
      await newService.initialize();

      expect(newService.currentSettings.musicVolume, equals(0.2));
      expect(newService.currentSettings.sfxVolume, equals(0.5));
      expect(newService.currentSettings.selectedThemeId, equals('sunset'));
    });

    test('4. Volume values are strictly clamped between 0.0 and 1.0', () async {
      await settingsService.update(musicVolume: 1.5, sfxVolume: -0.5);
      expect(settingsService.currentSettings.musicVolume, equals(1.0));
      expect(settingsService.currentSettings.sfxVolume, equals(0.0));
    });
  });
}
