import '../models/level_model.dart';

/// Evaluates level completion performance against authored star rules.
abstract class StarCalculator {
  /// Calculates stars awarded (1, 2, or 3) upon level completion.
  static int calculateStars({
    required StarRules starRules,
    required int movesCount,
    required double timeRemainingSeconds,
  }) {
    // 3 Stars criteria: moves <= threeStarMaxMoves AND timeRemaining >= threeStarMinRemainingSeconds
    if (movesCount <= starRules.threeStarMaxMoves &&
        timeRemainingSeconds >= starRules.threeStarMinRemainingSeconds) {
      return 3;
    }

    // 2 Stars criteria: moves <= twoStarMaxMoves AND timeRemaining >= twoStarMinRemainingSeconds
    if (movesCount <= starRules.twoStarMaxMoves &&
        timeRemainingSeconds >= starRules.twoStarMinRemainingSeconds) {
      return 2;
    }

    // Minimum completion award is 1 Star
    return 1;
  }
}
