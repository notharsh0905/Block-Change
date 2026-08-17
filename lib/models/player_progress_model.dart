import 'dart:convert';
import 'dart:math' as math;

/// Immutable model representing campaign progression state and level high scores.
class PlayerProgressModel {
  final int highestUnlockedLevel;
  final Set<int> completedLevels;
  final Map<int, int> starsByLevel;
  final Map<int, int> bestScoreByLevel;
  final Map<int, int> bestMovesByLevel;
  final Map<int, double> bestTimeByLevel;
  final int currentLevelId;
  final int selectedWorldId;

  const PlayerProgressModel({
    this.highestUnlockedLevel = 1,
    this.completedLevels = const {},
    this.starsByLevel = const {},
    this.bestScoreByLevel = const {},
    this.bestMovesByLevel = const {},
    this.bestTimeByLevel = const {},
    this.currentLevelId = 1,
    this.selectedWorldId = 1,
  });

  /// Factory constructor for a fresh game installation (only Level 1 unlocked).
  factory PlayerProgressModel.initial() {
    return const PlayerProgressModel(
      highestUnlockedLevel: 1,
      completedLevels: {},
      starsByLevel: {},
      bestScoreByLevel: {},
      bestMovesByLevel: {},
      bestTimeByLevel: {},
      currentLevelId: 1,
      selectedWorldId: 1,
    );
  }

  /// Checks if a given level ID (1..100) is unlocked.
  bool isLevelUnlocked(int levelId) {
    if (levelId <= 1) return true;
    if (levelId > 100) return false;
    return levelId <= highestUnlockedLevel;
  }

  /// Checks if a given world ID (1..10) is unlocked.
  bool isWorldUnlocked(int worldId) {
    if (worldId <= 1) return true;
    if (worldId > 10) return false;
    final firstLevelOfWorld = (worldId - 1) * 10 + 1;
    return isLevelUnlocked(firstLevelOfWorld);
  }

  int getStars(int levelId) => starsByLevel[levelId] ?? 0;
  int getBestScore(int levelId) => bestScoreByLevel[levelId] ?? 0;
  int getBestMoves(int levelId) => bestMovesByLevel[levelId] ?? 0;
  double getBestTime(int levelId) => bestTimeByLevel[levelId] ?? 0.0;
  bool get isCampaignCompleted =>
      completedLevels.length >= 100 || completedLevels.contains(100);

  /// Calculates total stars earned across all completed levels in a given world (1..10).
  int getWorldEarnedStars(int worldId) {
    int total = 0;
    final startLevel = (worldId - 1) * 10 + 1;
    final endLevel = startLevel + 9;
    for (int id = startLevel; id <= endLevel; id++) {
      total += getStars(id);
    }
    return total;
  }

  /// Calculates total completed levels in a given world (1..10).
  int getWorldCompletedCount(int worldId) {
    int total = 0;
    final startLevel = (worldId - 1) * 10 + 1;
    final endLevel = startLevel + 9;
    for (int id = startLevel; id <= endLevel; id++) {
      if (completedLevels.contains(id)) total++;
    }
    return total;
  }

  /// Single Authoritative Progression Calculation Rule (PRD Phase 4.1):
  /// - Completing Level N (N < 100) unlocks N + 1.
  /// - Completing Level 100 finishes campaign (never wraps to 1).
  /// - Replaying Level M (M < highestUnlockedLevel) updates scores if improved,
  ///   BUT PRESERVES highestUnlockedLevel.
  PlayerProgressModel recordCompletion({
    required int levelId,
    required int stars,
    required int score,
    required int moves,
    required double timeRemainingSeconds,
  }) {
    // 1. Calculate new highest unlocked level (never decreases)
    final bool isNewUnlockingCompletion = (levelId == highestUnlockedLevel);
    final int nextLevelCandidate = (levelId < 100) ? levelId + 1 : 100;

    final int newHighest = isNewUnlockingCompletion
        ? math.min(100, math.max(highestUnlockedLevel, nextLevelCandidate))
        : highestUnlockedLevel;

    final Set<int> newCompleted = Set<int>.from(completedLevels)..add(levelId);

    // 2. High score non-downgrading updates
    final int currentStars = getStars(levelId);
    final Map<int, int> newStars = Map<int, int>.from(starsByLevel);
    newStars[levelId] = math.max(currentStars, stars);

    final int currentScore = getBestScore(levelId);
    final Map<int, int> newScore = Map<int, int>.from(bestScoreByLevel);
    newScore[levelId] = math.max(currentScore, score);

    final int currentMoves = getBestMoves(levelId);
    final Map<int, int> newMoves = Map<int, int>.from(bestMovesByLevel);
    newMoves[levelId] = (currentMoves == 0)
        ? moves
        : math.min(currentMoves, moves);

    final double currentTime = getBestTime(levelId);
    final Map<int, double> newTime = Map<int, double>.from(bestTimeByLevel);
    newTime[levelId] = math.max(currentTime, timeRemainingSeconds);

    return copyWith(
      highestUnlockedLevel: newHighest,
      completedLevels: newCompleted,
      starsByLevel: newStars,
      bestScoreByLevel: newScore,
      bestMovesByLevel: newMoves,
      bestTimeByLevel: newTime,
      currentLevelId: newHighest,
      selectedWorldId: (newHighest - 1) ~/ 10 + 1,
    );
  }

  PlayerProgressModel copyWith({
    int? highestUnlockedLevel,
    Set<int>? completedLevels,
    Map<int, int>? starsByLevel,
    Map<int, int>? bestScoreByLevel,
    Map<int, int>? bestMovesByLevel,
    Map<int, double>? bestTimeByLevel,
    int? currentLevelId,
    int? selectedWorldId,
  }) {
    return PlayerProgressModel(
      highestUnlockedLevel: highestUnlockedLevel ?? this.highestUnlockedLevel,
      completedLevels: completedLevels ?? this.completedLevels,
      starsByLevel: starsByLevel ?? this.starsByLevel,
      bestScoreByLevel: bestScoreByLevel ?? this.bestScoreByLevel,
      bestMovesByLevel: bestMovesByLevel ?? this.bestMovesByLevel,
      bestTimeByLevel: bestTimeByLevel ?? this.bestTimeByLevel,
      currentLevelId: currentLevelId ?? this.currentLevelId,
      selectedWorldId: selectedWorldId ?? this.selectedWorldId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highestUnlockedLevel': highestUnlockedLevel,
      'completedLevels': completedLevels.toList(),
      'starsByLevel': starsByLevel.map((k, v) => MapEntry(k.toString(), v)),
      'bestScoreByLevel': bestScoreByLevel.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      'bestMovesByLevel': bestMovesByLevel.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      'bestTimeByLevel': bestTimeByLevel.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      'currentLevelId': currentLevelId,
      'selectedWorldId': selectedWorldId,
    };
  }

  factory PlayerProgressModel.fromJson(Map<String, dynamic> json) {
    Map<int, int> parseMapInt(dynamic mapData) {
      if (mapData == null) return {};
      final map = mapData as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(int.parse(k), (v as num).toInt()));
    }

    Map<int, double> parseMapDouble(dynamic mapData) {
      if (mapData == null) return {};
      final map = mapData as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(int.parse(k), (v as num).toDouble()));
    }

    final completedList =
        (json['completedLevels'] as List<dynamic>?)
            ?.map((e) => (e as num).toInt())
            .toSet() ??
        {};

    return PlayerProgressModel(
      highestUnlockedLevel:
          (json['highestUnlockedLevel'] as num?)?.toInt() ?? 1,
      completedLevels: completedList,
      starsByLevel: parseMapInt(json['starsByLevel']),
      bestScoreByLevel: parseMapInt(json['bestScoreByLevel']),
      bestMovesByLevel: parseMapInt(json['bestMovesByLevel']),
      bestTimeByLevel: parseMapDouble(json['bestTimeByLevel']),
      currentLevelId: (json['currentLevelId'] as num?)?.toInt() ?? 1,
      selectedWorldId: (json['selectedWorldId'] as num?)?.toInt() ?? 1,
    );
  }

  String encodeJson() => jsonEncode(toJson());

  factory PlayerProgressModel.decodeJson(String jsonString) {
    return PlayerProgressModel.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
}
