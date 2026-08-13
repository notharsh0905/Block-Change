/// Centralized AdMob ad unit configuration.
///
/// CRITICAL SECURITY & MONETIZATION RULE:
/// All IDs in development MUST be official Google test unit IDs.
/// NEVER commit live production AdMob unit IDs into client development source files.
abstract class AdConfig {
  /// Official Google Mobile Ads Test Unit IDs for Android
  /// Reference: https://developers.google.com/admob/android/test-ads
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  /// Active ad unit getters defaulting to test IDs.
  /// Production IDs will be supplied dynamically via environment configuration at build time.
  static String get bannerAdUnitId => testBannerAdUnitId;
  static String get interstitialAdUnitId => testInterstitialAdUnitId;
  static String get rewardedAdUnitId => testRewardedAdUnitId;

  /// Ad frequency capping defaults
  static const int minCompletedLevelsBeforeInterstitial = 3;
  static const Duration interstitialCooldown = Duration(minutes: 2);
}
