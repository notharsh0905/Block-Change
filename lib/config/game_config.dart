/// Core game rule boundaries, default timing parameters, and layout limits.
abstract class GameConfig {
  /// Grid size boundaries (PRD 2.1: 3x3 to 8x8 maximum).
  static const int minGridSize = 3;
  static const int maxGridSize = 8;

  /// Logical color palette size boundaries (PRD 2.2: at least 6 colors supported).
  static const int minColorCount = 3;
  static const int maxColorCount = 6;

  /// Default mechanics timing (seconds).
  static const double defaultFreezeDurationSeconds = 3.0;
  static const double defaultLockDurationSeconds = 5.0;
  static const double defaultRewardedExtraTimeSeconds = 15.0;

  /// Default chaos timing interval (seconds).
  static const double defaultChaosInitialInterval = 2.0;
  static const double defaultChaosMinimumInterval = 0.35;

  /// Maximum levels per world and total worlds.
  static const int levelsPerWorld = 10;
  static const int totalWorlds = 10;
  static const int totalCampaignLevels = totalWorlds * levelsPerWorld;
}
