import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/level_model.dart';

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

  /// Loads all 100 campaign levels across 10 worlds.
  static Future<List<LevelModel>> loadAllCampaignLevels() async {
    final allLevels = <LevelModel>[];
    for (int w = 1; w <= 10; w++) {
      final levels = await loadWorldLevels(w);
      allLevels.addAll(levels);
    }
    return allLevels;
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
    // Generate valid sample fallback levels for any requested world
    final startId = (worldId - 1) * 10 + 1;
    return List.generate(10, (index) {
      final id = startId + index;
      return LevelModel(
        id: id,
        worldId: worldId,
        name: 'World $worldId Level ${index + 1}',
        gridSize: 3 + (worldId > 5 ? 1 : 0),
        colorCount: 3 + (worldId > 3 ? 1 : 0),
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
        seed: 1000 + id,
        difficulty: Difficulty.easy,
      );
    });
  }
}
