/// Visual design system parameters and token constants.
abstract class ThemeConfig {
  /// Corner radius tokens
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusTile = 16.0;

  /// Elevation & 2.5D depth tokens
  static const double tileDepthOffset = 4.0;
  static const double shadowBlurRadius = 8.0;

  /// Animation duration tokens
  static const Duration tileTapAnimationDuration = Duration(milliseconds: 250);
  static const Duration screenTransitionDuration = Duration(milliseconds: 300);

  /// Logical game color hex values (PRD 6.2 baseline)
  static const int colorCoralHex = 0xFFFF7A7A;
  static const int colorMintHex = 0xFF73D99A;
  static const int colorSkyHex = 0xFF6FA8FF;
  static const int colorVioletHex = 0xFF9B7BFF;
  static const int colorSunshineHex = 0xFFFFD45C;
  static const int colorAquaHex = 0xFF55D6D6;
}
