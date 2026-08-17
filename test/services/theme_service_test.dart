import 'package:flutter_test/flutter_test.dart';
import 'package:block_change/services/progress_service.dart';
import 'package:block_change/services/settings_service.dart';
import 'package:block_change/services/theme_service.dart';

void main() {
  group('ThemeService & AppThemeModel Tests', () {
    late InMemoryProgressStorage storage;
    late SettingsService settingsService;
    late ThemeService themeService;

    setUp(() async {
      storage = InMemoryProgressStorage();
      settingsService = SettingsService.withStorage(storage);
      await settingsService.initialize();

      SettingsService.resetInstanceForTesting(testInstance: settingsService);
      themeService = ThemeService.instance;
    });

    test('1. Classic Dark theme is equipped by default', () {
      final theme = themeService.equippedTheme;
      expect(theme.id, equals('classic_dark'));
      expect(theme.name, equals('Classic Dark'));
    });

    test('2. Equipping different theme persists selection', () async {
      final oceanTheme = themeService.getThemeById('ocean');
      await themeService.equipTheme(oceanTheme);

      expect(themeService.equippedTheme.id, equals('ocean'));
      expect(settingsService.currentSettings.selectedThemeId, equals('ocean'));
    });

    test('3. Catalog contains all 5 required environment themes', () {
      final catalog = ThemeService.allThemes;
      expect(catalog.length, equals(5));
      final ids = catalog.map((t) => t.id).toList();
      expect(ids, containsAll(['classic_dark', 'bright_candy', 'ocean', 'sunset', 'lavender']));
    });
  });
}
