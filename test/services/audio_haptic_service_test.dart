import 'package:flutter_test/flutter_test.dart';
import 'package:block_change/models/game_settings_model.dart';
import 'package:block_change/services/audio_service.dart';
import 'package:block_change/services/haptic_service.dart';
import 'package:block_change/services/progress_service.dart';
import 'package:block_change/services/settings_service.dart';

void main() {
  group('AudioService & HapticService Interception Tests', () {
    late InMemoryProgressStorage storage;
    late SettingsService settingsService;

    setUp(() async {
      storage = InMemoryProgressStorage();
      settingsService = SettingsService.withStorage(storage);
      await settingsService.initialize();
    });

    test('1. AudioService respects sfxEnabled and volume settings', () async {
      final playedAssets = <String>[];
      final audioService = AudioService.withSettings(
        settingsService,
        onPlayback: (path, volume, isMusic) {
          playedAssets.add(path);
        },
      );

      // Default sfxEnabled = true -> triggers playback
      await audioService.playTileTap();
      expect(playedAssets, contains('audio/sfx/tile_tap.wav'));

      // Disable SFX -> no playback triggers
      playedAssets.clear();
      await settingsService.update(sfxEnabled: false);
      await audioService.playBomb();
      expect(playedAssets, isEmpty);
    });

    test('2. AudioService background music respects musicEnabled setting', () async {
      final musicTracks = <String>[];
      final audioService = AudioService.withSettings(
        settingsService,
        onPlayback: (path, volume, isMusic) {
          if (isMusic) musicTracks.add(path);
        },
      );

      await audioService.playMenuMusic();
      expect(musicTracks, contains('audio/music/menu_theme.wav'));

      // Disable Music -> stops music playback
      musicTracks.clear();
      await settingsService.update(musicEnabled: false);
      await audioService.playGameplayMusic();
      expect(musicTracks, isEmpty);
    });

    test('3. HapticService respects hapticsEnabled and intensity settings', () async {
      final triggeredFeedback = <HapticFeedbackType>[];
      final hapticService = HapticService.withSettings(
        settingsService,
        onFeedback: (type) async {
          triggeredFeedback.add(type);
        },
      );

      // Default medium intensity tile tap -> light impact
      await hapticService.tileTap();
      expect(triggeredFeedback.last, equals(HapticFeedbackType.light));

      // Disable haptics -> no feedback
      triggeredFeedback.clear();
      await settingsService.update(hapticsEnabled: false);
      await hapticService.bombExplosion();
      expect(triggeredFeedback, isEmpty);
    });

    test('4. HapticService damps intensity when reducedMotion is true', () async {
      final triggeredFeedback = <HapticFeedbackType>[];
      final hapticService = HapticService.withSettings(
        settingsService,
        onFeedback: (type) async {
          triggeredFeedback.add(type);
        },
      );

      await settingsService.update(
        hapticsEnabled: true,
        hapticIntensity: HapticIntensity.high,
        reducedMotion: true,
      );

      await hapticService.bombExplosion();
      // High intensity bomb explosion normally vibrate, reduced motion steps down to heavy
      expect(triggeredFeedback.last, equals(HapticFeedbackType.heavy));
    });
  });
}
