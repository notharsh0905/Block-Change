import 'package:flutter/material.dart';

import '../models/app_theme_model.dart';
import 'settings_service.dart';

/// Centralized catalog and environment provider for application visual themes.
class ThemeService {
  static ThemeService? _instance;
  static ThemeService get instance => _instance ??= ThemeService._();

  final SettingsService _settingsService;

  ThemeService._({SettingsService? settingsService})
      : _settingsService = settingsService ?? SettingsService.instance;

  @visibleForTesting
  static void resetInstanceForTesting({ThemeService? testInstance}) {
    _instance = testInstance;
  }

  /// All 5 defined themes in the application catalog.
  static const List<AppThemeModel> allThemes = [
    AppThemeModel(
      id: 'classic_dark',
      name: 'Classic Dark',
      description: 'Sleek dark void aesthetic with vibrant neon highlights.',
      backgroundGradient: LinearGradient(
        colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      surfaceColor: Color(0xFF1E293B),
      cardColor: Color(0xFF334155),
      primaryAccent: Color(0xFF6366F1),
      secondaryAccent: Color(0xFF818CF8),
      textPrimary: Colors.white,
      textSecondary: Color(0xFF94A3B8),
      boardFrameColor: Color(0xFF475569),
    ),
    AppThemeModel(
      id: 'bright_candy',
      name: 'Bright Candy',
      description: 'Playful pastel candy sky with energetic sweet accents.',
      backgroundGradient: LinearGradient(
        colors: [Color(0xFFFFF0F5), Color(0xFFE6F0FA)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      surfaceColor: Colors.white,
      cardColor: Color(0xFFF1F5F9),
      primaryAccent: Color(0xFFFF007F),
      secondaryAccent: Color(0xFF00BBF9),
      textPrimary: Color(0xFF0F172A),
      textSecondary: Color(0xFF64748B),
      boardFrameColor: Color(0xFFCBD5E1),
    ),
    AppThemeModel(
      id: 'ocean',
      name: 'Deep Ocean',
      description: 'Cool aquatic cyan abyss with refreshing seafoam highlights.',
      backgroundGradient: LinearGradient(
        colors: [Color(0xFF0B192C), Color(0xFF1E3E62)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      surfaceColor: Color(0xFF1E2A38),
      cardColor: Color(0xFF2D3C4D),
      primaryAccent: Color(0xFF00F5D4),
      secondaryAccent: Color(0xFF00BBF9),
      textPrimary: Colors.white,
      textSecondary: Color(0xFF94A3B8),
      boardFrameColor: Color(0xFF3B4E63),
    ),
    AppThemeModel(
      id: 'sunset',
      name: 'Dusk Sunset',
      description: 'Warm twilight gradient with glowing orange and magenta accents.',
      backgroundGradient: LinearGradient(
        colors: [Color(0xFF2D0B32), Color(0xFF4D194D)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      surfaceColor: Color(0xFF38143D),
      cardColor: Color(0xFF4E2055),
      primaryAccent: Color(0xFFFF6B6B),
      secondaryAccent: Color(0xFFFFBE0B),
      textPrimary: Colors.white,
      textSecondary: Color(0xFFD8B4FE),
      boardFrameColor: Color(0xFF6B2B75),
    ),
    AppThemeModel(
      id: 'lavender',
      name: 'Soft Lavender',
      description: 'Elegant purple atmosphere with calming pastel serenity.',
      backgroundGradient: LinearGradient(
        colors: [Color(0xFF1F1A30), Color(0xFF322B48)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      surfaceColor: Color(0xFF28223D),
      cardColor: Color(0xFF3B3356),
      primaryAccent: Color(0xFFB5179E),
      secondaryAccent: Color(0xFF7209B7),
      textPrimary: Colors.white,
      textSecondary: Color(0xFFC084FC),
      boardFrameColor: Color(0xFF524677),
    ),
  ];

  /// Gets a theme by ID. Defaults to Classic Dark if not found.
  AppThemeModel getThemeById(String id) {
    return allThemes.firstWhere(
      (t) => t.id == id,
      orElse: () => allThemes.first,
    );
  }

  /// Currently equipped visual environment theme.
  AppThemeModel get equippedTheme {
    final selectedId = _settingsService.currentSettings.selectedThemeId;
    return getThemeById(selectedId);
  }

  /// Equips a theme and persists selection.
  Future<void> equipTheme(AppThemeModel theme) async {
    await _settingsService.update(selectedThemeId: theme.id);
  }
}
