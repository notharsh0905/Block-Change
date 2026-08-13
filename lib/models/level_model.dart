import 'tile_model.dart';

/// Level difficulty tiers.
enum Difficulty { easy, medium, hard, expert, master }

/// Automatic pressure system configuration.
class ChaosConfig {
  final bool enabled;
  final double initialInterval;
  final double minimumInterval;
  final bool adaptive;

  const ChaosConfig({
    required this.enabled,
    this.initialInterval = 2.0,
    this.minimumInterval = 0.35,
    this.adaptive = false,
  });

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'initialInterval': initialInterval,
    'minimumInterval': minimumInterval,
    'adaptive': adaptive,
  };

  factory ChaosConfig.fromJson(Map<String, dynamic> json) {
    return ChaosConfig(
      enabled: json['enabled'] as bool? ?? false,
      initialInterval: (json['initialInterval'] as num?)?.toDouble() ?? 2.0,
      minimumInterval: (json['minimumInterval'] as num?)?.toDouble() ?? 0.35,
      adaptive: json['adaptive'] as bool? ?? false,
    );
  }
}

/// Level star achievement criteria thresholds.
class StarRules {
  final int threeStarMaxMoves;
  final double threeStarMinRemainingSeconds;
  final int twoStarMaxMoves;
  final double twoStarMinRemainingSeconds;

  const StarRules({
    required this.threeStarMaxMoves,
    required this.threeStarMinRemainingSeconds,
    required this.twoStarMaxMoves,
    required this.twoStarMinRemainingSeconds,
  });

  Map<String, dynamic> toJson() => {
    'threeStarMaxMoves': threeStarMaxMoves,
    'threeStarMinRemainingSeconds': threeStarMinRemainingSeconds,
    'twoStarMaxMoves': twoStarMaxMoves,
    'twoStarMinRemainingSeconds': twoStarMinRemainingSeconds,
  };

  factory StarRules.fromJson(Map<String, dynamic> json) {
    return StarRules(
      threeStarMaxMoves: json['threeStarMaxMoves'] as int,
      threeStarMinRemainingSeconds:
          (json['threeStarMinRemainingSeconds'] as num).toDouble(),
      twoStarMaxMoves: json['twoStarMaxMoves'] as int,
      twoStarMinRemainingSeconds: (json['twoStarMinRemainingSeconds'] as num)
          .toDouble(),
    );
  }
}

/// Complete authored level data schema.
class LevelModel {
  final int id;
  final int worldId;
  final String name;
  final int gridSize;
  final int colorCount;
  final int targetColor;
  final List<List<int>> initialBoard;
  final List<TileDefinition> specialTiles;
  final double timeLimitSeconds;
  final ChaosConfig chaosConfig;
  final StarRules starRules;
  final int seed;
  final Difficulty difficulty;
  final String? tutorialStep;
  final int rulesVersion;

  const LevelModel({
    required this.id,
    required this.worldId,
    required this.name,
    required this.gridSize,
    required this.colorCount,
    required this.targetColor,
    required this.initialBoard,
    required this.specialTiles,
    required this.timeLimitSeconds,
    required this.chaosConfig,
    required this.starRules,
    required this.seed,
    required this.difficulty,
    this.tutorialStep,
    this.rulesVersion = 1,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'worldId': worldId,
    'name': name,
    'gridSize': gridSize,
    'colorCount': colorCount,
    'targetColor': targetColor,
    'initialBoard': initialBoard,
    'specialTiles': specialTiles.map((t) => t.toJson()).toList(),
    'timeLimitSeconds': timeLimitSeconds,
    'chaosConfig': chaosConfig.toJson(),
    'starRules': starRules.toJson(),
    'seed': seed,
    'difficulty': difficulty.name,
    'tutorialStep': tutorialStep,
    'rulesVersion': rulesVersion,
  };

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    final rawBoard = json['initialBoard'] as List<dynamic>;
    final board = rawBoard
        .map((row) => (row as List<dynamic>).map((e) => e as int).toList())
        .toList();

    final rawTiles = json['specialTiles'] as List<dynamic>? ?? [];
    final specialTiles = rawTiles
        .map((t) => TileDefinition.fromJson(t as Map<String, dynamic>))
        .toList();

    return LevelModel(
      id: json['id'] as int,
      worldId: json['worldId'] as int,
      name: json['name'] as String,
      gridSize: json['gridSize'] as int,
      colorCount: json['colorCount'] as int,
      targetColor: json['targetColor'] as int,
      initialBoard: board,
      specialTiles: specialTiles,
      timeLimitSeconds: (json['timeLimitSeconds'] as num).toDouble(),
      chaosConfig: ChaosConfig.fromJson(
        json['chaosConfig'] as Map<String, dynamic>,
      ),
      starRules: StarRules.fromJson(json['starRules'] as Map<String, dynamic>),
      seed: json['seed'] as int,
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      tutorialStep: json['tutorialStep'] as String?,
      rulesVersion: json['rulesVersion'] as int? ?? 1,
    );
  }
}
