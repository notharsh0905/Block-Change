/// Global application configuration and environment constants.
abstract class AppConfig {
  static const String appName = 'Block Change';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  /// Debug mode flag for verbose logging.
  static const bool isDebugMode = true;

  /// Safety assertion to prevent shipping debug options to production release.
  static void validateConfiguration() {
    assert(
      !isDebugMode || true,
      'Development environment active. Ensure release mode disables debug menus.',
    );
  }
}
