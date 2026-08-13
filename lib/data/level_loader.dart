import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/level_model.dart';
import '../models/tile_model.dart';

/// Data service for loading authored campaign levels from JSON assets.
abstract class LevelLoader {
  /// Loads world level collection from JSON asset `assets/levels/world_{worldId}.json`.
  static Future<List<LevelModel>> loadWorldLevels(int worldId) async {
    final formattedWorld = worldId.toString().padLeft(2, '0');
    final assetPath = 'assets/levels/world_$formattedWorld.json';

    try {
      final jsonString = await rootBundle.loadString(assetPath);
      return parseWorldLevels(jsonString);
    } catch (_) {
      // Fallback for uncreated asset files or test environment
      return getFallbackWorldLevels(worldId);
    }
  }

  /// Parses JSON string representation of a world level set.
  static List<LevelModel> parseWorldLevels(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final List<dynamic> levelList = data['levels'] as List<dynamic>;
    return levelList
        .map((l) => LevelModel.fromJson(l as Map<String, dynamic>))
        .toList();
  }

  /// Provides fallback/sample level data definitions for testing and dev.
  static List<LevelModel> getFallbackWorldLevels(int worldId) {
    return [
      LevelModel(
        id: (worldId - 1) * 10 + 1,
        worldId: worldId,
        name: 'First Tap',
        gridSize: 3,
        colorCount: 3,
        targetColor: 0,
        initialBoard: const [
          [1, 1, 1],
          [1, 0, 1],
          [1, 1, 1],
        ],
        specialTiles: const [],
        timeLimitSeconds: 60.0,
        chaosConfig: const ChaosConfig(enabled: false),
        starRules: const StarRules(
          threeStarMaxMoves: 5,
          threeStarMinRemainingSeconds: 45.0,
          twoStarMaxMoves: 10,
          twoStarMinRemainingSeconds: 30.0,
        ),
        seed: 1001,
        difficulty: Difficulty.easy,
        tutorialStep: 'tap_to_change',
      ),
      LevelModel(
        id: (worldId - 1) * 10 + 2,
        worldId: worldId,
        name: 'Color Shift',
        gridSize: 3,
        colorCount: 3,
        targetColor: 1,
        initialBoard: const [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0],
        ],
        specialTiles: const [],
        timeLimitSeconds: 60.0,
        chaosConfig: const ChaosConfig(enabled: false),
        starRules: const StarRules(
          threeStarMaxMoves: 10,
          threeStarMinRemainingSeconds: 40.0,
          twoStarMaxMoves: 15,
          twoStarMinRemainingSeconds: 25.0,
        ),
        seed: 1002,
        difficulty: Difficulty.easy,
      ),
      LevelModel(
        id: (worldId - 1) * 10 + 3,
        worldId: worldId,
        name: 'Boom Introduction',
        gridSize: 4,
        colorCount: 4,
        targetColor: 0,
        initialBoard: const [
          [1, 1, 1, 1],
          [1, 0, 0, 1],
          [1, 0, 0, 1],
          [1, 1, 1, 1],
        ],
        specialTiles: const [
          TileDefinition(row: 1, column: 1, type: TileType.bomb),
        ],
        timeLimitSeconds: 60.0,
        chaosConfig: const ChaosConfig(enabled: false),
        starRules: const StarRules(
          threeStarMaxMoves: 4,
          threeStarMinRemainingSeconds: 45.0,
          twoStarMaxMoves: 8,
          twoStarMinRemainingSeconds: 30.0,
        ),
        seed: 1003,
        difficulty: Difficulty.medium,
      ),
    ];
  }
}
