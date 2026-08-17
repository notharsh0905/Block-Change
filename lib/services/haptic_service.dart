import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/game_settings_model.dart';
import 'settings_service.dart';

/// Function signature for haptic execution override in tests.
typedef HapticFeedbackCallback = Future<void> Function(HapticFeedbackType type);

enum HapticFeedbackType {
  selection,
  light,
  medium,
  heavy,
  vibrate,
}

/// Centralized service providing semantic haptic feedback based on player preferences.
class HapticService {
  static HapticService? _instance;
  static HapticService get instance => _instance ??= HapticService._();

  final SettingsService _settingsService;
  final HapticFeedbackCallback? _testFeedbackCallback;

  HapticService._({
    SettingsService? settingsService,
    this._testFeedbackCallback,
  })  : _settingsService = settingsService ?? SettingsService.instance;

  /// Factory for testing with explicit SettingsService or feedback callback.
  factory HapticService.withSettings(
    SettingsService settingsService, {
    HapticFeedbackCallback? onFeedback,
  }) {
    return HapticService._(
      settingsService: settingsService,
      testFeedbackCallback: onFeedback,
    );
  }

  @visibleForTesting
  static void resetInstanceForTesting({HapticService? testInstance}) {
    _instance = testInstance;
  }

  GameSettingsModel get _settings => _settingsService.currentSettings;

  /// Executes haptic feedback matching requested level adjusted for intensity & settings.
  Future<void> _trigger(HapticFeedbackType baseType) async {
    if (!_settings.hapticsEnabled) return;

    var targetType = baseType;

    // Adjust for reduced motion
    if (_settings.reducedMotion) {
      switch (targetType) {
        case HapticFeedbackType.vibrate:
          targetType = HapticFeedbackType.heavy;
          break;
        case HapticFeedbackType.heavy:
          targetType = HapticFeedbackType.medium;
          break;
        case HapticFeedbackType.medium:
          targetType = HapticFeedbackType.light;
          break;
        case HapticFeedbackType.light:
        case HapticFeedbackType.selection:
          targetType = HapticFeedbackType.selection;
          break;
      }
    }

    // Adjust for intensity setting
    switch (_settings.hapticIntensity) {
      case HapticIntensity.low:
        if (targetType == HapticFeedbackType.heavy || targetType == HapticFeedbackType.vibrate) {
          targetType = HapticFeedbackType.medium;
        } else if (targetType == HapticFeedbackType.medium) {
          targetType = HapticFeedbackType.light;
        } else if (targetType == HapticFeedbackType.light) {
          targetType = HapticFeedbackType.selection;
        }
        break;
      case HapticIntensity.medium:
        // Default mapping
        break;
      case HapticIntensity.high:
        if (targetType == HapticFeedbackType.medium) {
          targetType = HapticFeedbackType.heavy;
        } else if (targetType == HapticFeedbackType.light) {
          targetType = HapticFeedbackType.medium;
        }
        break;
    }

    final callback = _testFeedbackCallback;
    if (callback != null) {
      await callback(targetType);
      return;
    }

    try {
      switch (targetType) {
        case HapticFeedbackType.selection:
          await HapticFeedback.selectionClick();
          break;
        case HapticFeedbackType.light:
          await HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.medium:
          await HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavy:
          await HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.vibrate:
          await HapticFeedback.vibrate();
          break;
      }
    } catch (_) {
      // Ignored in desktop / web / headless test environments without haptic hardware
    }
  }

  // --- Semantic Public API ---

  Future<void> lightTap() => _trigger(HapticFeedbackType.selection);
  Future<void> tileTap() => _trigger(HapticFeedbackType.light);
  Future<void> specialTile() => _trigger(HapticFeedbackType.medium);
  Future<void> bombExplosion() => _trigger(HapticFeedbackType.heavy);
  Future<void> freeze() => _trigger(HapticFeedbackType.medium);
  Future<void> lockTap() => _trigger(HapticFeedbackType.selection);
  Future<void> levelComplete() => _trigger(HapticFeedbackType.heavy);
  Future<void> starReveal() => _trigger(HapticFeedbackType.medium);
  Future<void> error() => _trigger(HapticFeedbackType.medium);
  Future<void> buttonPress() => _trigger(HapticFeedbackType.selection);
}
