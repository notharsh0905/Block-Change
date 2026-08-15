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

  /// Loads specific level by ID (1..100) from campaign world JSON asset.
  static Future<LevelModel?> loadLevelById(int levelId) async {
    if (levelId < 1 || levelId > 100) return null;
    final worldId = (levelId - 1) ~/ 10 + 1;
    final levels = await loadWorldLevels(worldId);
    for (final l in levels) {
      if (l.id == levelId) return l;
    }
    return null;
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

  /// Authored World 1 Fallback Levels matching exact PRD archetype redesign.
  static const List<String> kWorld1Names = [
    'First Tap',
    'Two Steps',
    'Almost There',
    'Chaos Arrives',
    'Beat the Clock',
    'Corner Case',
    'Color Trap',
    'Clean Run',
    'Chaos Rush',
    'First Challenge',
  ];

  /// Provides fallback/sample level data definitions for testing and dev.
  static List<LevelModel> getFallbackWorldLevels(int worldId) {
    final startId = (worldId - 1) * 10 + 1;
    return List.generate(10, (index) {
      final id = startId + index;

      if (worldId == 1) {
        final name = kWorld1Names[index];
        final size = index >= 6 ? 4 : 3;
        final colors = index >= 6 ? 4 : 3;
        List<List<int>> board;
        if (index == 0) {
          board = [
            [0, 0, 0],
            [0, 2, 0],
            [0, 0, 0]
          ];
        } else if (index == 1) {
          board = [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0]
          ];
        } else if (index == 2) {
          board = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 2]
          ];
        } else if (index == 3) {
          board = [
            [0, 2, 0],
            [2, 0, 2],
            [0, 2, 0]
          ];
        } else if (index == 4) {
          board = [
            [2, 0, 2],
            [0, 2, 0],
            [2, 0, 2]
          ];
        } else if (index == 5) {
          board = [
            [1, 0, 1],
            [0, 0, 0],
            [1, 0, 1]
          ];
        } else if (index == 6) {
          board = [
            [0, 0, 0, 0],
            [0, 3, 3, 0],
            [0, 3, 3, 0],
            [0, 0, 0, 0]
          ];
        } else if (index == 7) {
          board = [
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 3, 0],
            [0, 0, 0, 0]
          ];
        } else if (index == 8) {
          board = [
            [0, 3, 0, 3],
            [3, 0, 3, 0],
            [0, 3, 0, 3],
            [3, 0, 3, 0]
          ];
        } else {
          board = [
            [3, 3, 3, 3],
            [3, 0, 0, 3],
            [3, 0, 0, 3],
            [3, 3, 3, 3]
          ];
        }

        return LevelModel(
          id: id,
          worldId: 1,
          name: name,
          gridSize: size,
          colorCount: colors,
          targetColor: 0,
          initialBoard: board,
          specialTiles: const [],
          timeLimitSeconds: (index == 4) ? 25.0 : 60.0,
          chaosConfig: ChaosConfig(
            enabled: (index == 3 || index == 8 || index == 9),
            initialInterval: (index == 8) ? 2.5 : 4.0,
          ),
          starRules: const StarRules(
            threeStarMaxMoves: 5,
            threeStarMinRemainingSeconds: 40.0,
            twoStarMaxMoves: 10,
            twoStarMinRemainingSeconds: 25.0,
          ),
          seed: 1000 + id,
          difficulty: Difficulty.easy,
        );
      }

      final gridSize = 3 + (worldId > 5 ? 1 : 0);
      final initialBoard = List.generate(
        gridSize,
        (_) => List.filled(gridSize, 0),
      );

      return LevelModel(
        id: id,
        worldId: worldId,
        name: 'World $worldId Level ${index + 1}',
        gridSize: gridSize,
        colorCount: 3 + (worldId > 3 ? 1 : 0),
        targetColor: 0,
        initialBoard: initialBoard,
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
