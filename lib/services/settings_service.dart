import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../models/game_settings_model.dart';
import 'progress_service.dart'; // Reuses IProgressStorage interface

const String kGameSettingsStorageKey = 'block_change_game_settings_v1';

/// Controller managing local persistence and reactive state updates for player settings.
class SettingsService {
  static SettingsService? _instance;
  static SettingsService get instance => _instance ??= SettingsService._();

  final IProgressStorage _storage;
  final ValueNotifier<GameSettingsModel> settingsNotifier;

  bool _initialized = false;

  SettingsService._({IProgressStorage? storage})
      : _storage = storage ?? SharedPreferencesStorage(),
        settingsNotifier = ValueNotifier<GameSettingsModel>(
          GameSettingsModel.defaultSettings,
        );

  /// Testing factory allowing mock/in-memory storage overrides.
  factory SettingsService.withStorage(IProgressStorage storage) {
    return SettingsService._(storage: storage);
  }

  /// Reset singleton for testing clean states.
  @visibleForTesting
  static void resetInstanceForTesting({SettingsService? testInstance}) {
    _instance = testInstance;
  }

  GameSettingsModel get currentSettings => settingsNotifier.value;

  /// Initializes setting values from local storage.
  Future<GameSettingsModel> initialize() async {
    if (_initialized && _storage is SharedPreferencesStorage) {
      return settingsNotifier.value;
    }

    try {
      final rawJson = await _storage.getString(kGameSettingsStorageKey);
      if (rawJson != null && rawJson.isNotEmpty) {
        final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
        settingsNotifier.value = GameSettingsModel.fromJson(decoded);
      } else {
        settingsNotifier.value = GameSettingsModel.defaultSettings;
      }
    } catch (e) {
      debugPrint('SettingsService initialization error: $e');
      settingsNotifier.value = GameSettingsModel.defaultSettings;
    }

    _initialized = true;
    return settingsNotifier.value;
  }

  /// Updates settings and persists changes locally.
  Future<void> updateSettings(GameSettingsModel newSettings) async {
    settingsNotifier.value = newSettings;

    try {
      final rawJson = jsonEncode(newSettings.toJson());
      await _storage.setString(kGameSettingsStorageKey, rawJson);
    } catch (e) {
      debugPrint('SettingsService updateSettings error: $e');
    }
  }

  /// Helper to patch specific setting values cleanly.
  Future<void> update({
    bool? musicEnabled,
    double? musicVolume,
    bool? sfxEnabled,
    double? sfxVolume,
    bool? hapticsEnabled,
    HapticIntensity? hapticIntensity,
    bool? showTutorial,
    bool? reducedMotion,
    String? selectedSkinId,
    String? selectedThemeId,
  }) async {
    final updated = currentSettings.copyWith(
      musicEnabled: musicEnabled,
      musicVolume: musicVolume,
      sfxEnabled: sfxEnabled,
      sfxVolume: sfxVolume,
      hapticsEnabled: hapticsEnabled,
      hapticIntensity: hapticIntensity,
      showTutorial: showTutorial,
      reducedMotion: reducedMotion,
      selectedSkinId: selectedSkinId,
      selectedThemeId: selectedThemeId,
    );
    await updateSettings(updated);
  }

  /// Reset all settings to factory default.
  Future<void> resetToDefaults() async {
    await updateSettings(GameSettingsModel.defaultSettings);
  }
}
