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

  /// Checks if a given level ID is accessible to the player.
  bool isLevelUnlocked(int levelId) {
    if (levelId <= 1) return true;
    return levelId <= highestUnlockedLevel;
  }

  /// Checks if a given world ID (1..10) is accessible.
  bool isWorldUnlocked(int worldId) {
    if (worldId <= 1) return true;
    final firstLevelOfWorld = (worldId - 1) * 10 + 1;
    return isLevelUnlocked(firstLevelOfWorld);
  }

  int getStars(int levelId) => starsByLevel[levelId] ?? 0;
  int getBestScore(int levelId) => bestScoreByLevel[levelId] ?? 0;
  int getBestMoves(int levelId) => bestMovesByLevel[levelId] ?? 0;
  double getBestTime(int levelId) => bestTimeByLevel[levelId] ?? 0.0;

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

  /// Records a successful level completion and unlocks next level without downgrading best scores.
  PlayerProgressModel recordCompletion({
    required int levelId,
    required int stars,
    required int score,
    required int moves,
    required double timeRemainingSeconds,
  }) {
    final nextLevel = math.min(100, levelId + 1);
    final newHighest = math.max(highestUnlockedLevel, nextLevel);

    final newCompleted = Set<int>.from(completedLevels)..add(levelId);

    // Keep highest stars earned
    final currentStars = getStars(levelId);
    final newStars = Map<int, int>.from(starsByLevel);
    newStars[levelId] = math.max(currentStars, stars);

    // Keep highest score
    final currentScore = getBestScore(levelId);
    final newScore = Map<int, int>.from(bestScoreByLevel);
    newScore[levelId] = math.max(currentScore, score);

    // Keep lowest (best) move count
    final currentMoves = getBestMoves(levelId);
    final newMoves = Map<int, int>.from(bestMovesByLevel);
    newMoves[levelId] = (currentMoves == 0)
        ? moves
        : math.min(currentMoves, moves);

    // Keep highest remaining time
    final currentTime = getBestTime(levelId);
    final newTime = Map<int, double>.from(bestTimeByLevel);
    newTime[levelId] = math.max(currentTime, timeRemainingSeconds);

    return copyWith(
      highestUnlockedLevel: newHighest,
      completedLevels: newCompleted,
      starsByLevel: newStars,
      bestScoreByLevel: newScore,
      bestMovesByLevel: newMoves,
      bestTimeByLevel: newTime,
      currentLevelId: nextLevel,
      selectedWorldId: (nextLevel - 1) ~/ 10 + 1,
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
