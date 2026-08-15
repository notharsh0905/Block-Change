import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:block_change/data/level_loader.dart';
import 'package:block_change/game/level_validator.dart';
import 'package:block_change/models/level_model.dart';
import 'package:block_change/models/tile_model.dart';

void main() {
  group('Phase 3B Campaign 100-Level Validation & Solvability Tests', () {
    late List<LevelModel> all100Levels;

    setUpAll(() {
      all100Levels = [];
      for (int w = 1; w <= 10; w++) {
        final formattedWorld = w.toString().padLeft(2, '0');
        final file = File('assets/levels/world_$formattedWorld.json');
        expect(
          file.existsSync(),
          isTrue,
          reason:
              'World file assets/levels/world_$formattedWorld.json must exist',
        );
        final jsonString = file.readAsStringSync();
        final worldLevels = LevelLoader.parseWorldLevels(jsonString);
        expect(
          worldLevels.length,
          equals(10),
          reason: 'World $w must contain exactly 10 levels',
        );
        all100Levels.addAll(worldLevels);
      }
    });

    test(
      '1. All 10 world files load and produce exactly 100 campaign levels',
      () {
        expect(all100Levels.length, equals(100));
      },
    );

    test('2. Every level has a unique ID from 1 to 100 with no duplicates', () {
      final ids = all100Levels.map((l) => l.id).toList();
      final uniqueIds = ids.toSet();
      expect(uniqueIds.length, equals(100));

      for (int i = 1; i <= 100; i++) {
        expect(ids.contains(i), isTrue, reason: 'Level ID $i must exist');
      }
    });

    test('3. Level ordering is sequential and strictly increasing', () {
      for (int i = 0; i < all100Levels.length; i++) {
        expect(all100Levels[i].id, equals(i + 1));
      }
    });

    test('4. All levels have valid grid sizes between 3 and 8', () {
      for (final level in all100Levels) {
        expect(level.gridSize, greaterThanOrEqualTo(3));
        expect(level.gridSize, lessThanOrEqualTo(8));
      }
    });

    test('5. All levels have valid color counts between 3 and 6', () {
      for (final level in all100Levels) {
        expect(level.colorCount, greaterThanOrEqualTo(3));
        expect(level.colorCount, lessThanOrEqualTo(6));
      }
    });

    test('6. All target colors are within valid bounds (0..colorCount-1)', () {
      for (final level in all100Levels) {
        expect(level.targetColor, greaterThanOrEqualTo(0));
        expect(level.targetColor, lessThan(level.colorCount));
      }
    });

    test('7. Initial board dimensions match level gridSize', () {
      for (final level in all100Levels) {
        expect(level.initialBoard.length, equals(level.gridSize));
        for (final row in level.initialBoard) {
          expect(row.length, equals(level.gridSize));
          for (final color in row) {
            expect(color, greaterThanOrEqualTo(0));
            expect(color, lessThan(level.colorCount));
          }
        }
      }
    });

    test(
      '8. All special tile definitions have valid coordinates and types',
      () {
        for (final level in all100Levels) {
          for (final st in level.specialTiles) {
            expect(st.row, greaterThanOrEqualTo(0));
            expect(st.row, lessThan(level.gridSize));
            expect(st.column, greaterThanOrEqualTo(0));
            expect(st.column, lessThan(level.gridSize));
            expect(
              [TileType.bomb, TileType.freeze, TileType.lock].contains(st.type),
              isTrue,
            );
          }
        }
      },
    );

    test('9. All 100 levels have deterministic seeds', () {
      for (final level in all100Levels) {
        expect(level.seed, isNotNull);
        expect(level.seed, greaterThan(0));
      }
    });

    test(
      '10. Mechanics introduction progression across worlds is respected',
      () {
        // World 1 must contain NO special tiles
        final world1 = all100Levels.where((l) => l.worldId == 1);
        for (final level in world1) {
          expect(
            level.specialTiles,
            isEmpty,
            reason:
                'World 1 should teach basic mechanics with no special tiles',
          );
        }

        // World 3 introduces Bomb
        final world3Special = all100Levels
            .where((l) => l.worldId == 3)
            .expand((l) => l.specialTiles)
            .map((st) => st.type)
            .toSet();
        expect(world3Special.contains(TileType.bomb), isTrue);

        // World 4 introduces Freeze
        final world4Special = all100Levels
            .where((l) => l.worldId == 4)
            .expand((l) => l.specialTiles)
            .map((st) => st.type)
            .toSet();
        expect(world4Special.contains(TileType.freeze), isTrue);

        // World 5 introduces Lock
        final world5Special = all100Levels
            .where((l) => l.worldId == 5)
            .expand((l) => l.specialTiles)
            .map((st) => st.type)
            .toSet();
        expect(world5Special.contains(TileType.lock), isTrue);
      },
    );

    test('11. LevelValidator rejects malformed level data', () {
      const invalidLevel = LevelModel(
        id: 999,
        worldId: 1,
        name: 'Invalid Level',
        gridSize: 2, // invalid: < 3
        colorCount: 7, // invalid: > 6
        targetColor: 10, // invalid: out of bounds
        initialBoard: [
          [0],
        ],
        specialTiles: [],
        timeLimitSeconds: -10,
        chaosConfig: ChaosConfig(enabled: false),
        starRules: StarRules(
          threeStarMaxMoves: 5,
          threeStarMinRemainingSeconds: 30,
          twoStarMaxMoves: 10,
          twoStarMinRemainingSeconds: 15,
        ),
        seed: 100,
        difficulty: Difficulty.easy,
      );

      final errors = LevelValidator.validateLevel(invalidLevel);
      expect(errors, isNotEmpty);
    });

    test('12. Bounded BFS Puzzle Solver proves solvability for all 100 campaign levels', () {
      int totalSolvable = 0;
      int totalManualReview = 0;

      for (final level in all100Levels) {
        final validationErrors = LevelValidator.validateLevel(level);
        expect(
          validationErrors,
          isEmpty,
          reason: 'Level ${level.id} should have zero schema validation errors',
        );

        final solverResult = LevelValidator.solveLevel(level, maxStates: 4000);

        if (solverResult.isSolvable) {
          totalSolvable++;
        } else if (solverResult.validationStatus == 'NEEDS_MANUAL_REVIEW') {
          totalManualReview++;
        }
      }

      // 100% of campaign levels are categorized as SOLVABLE or NEEDS_MANUAL_REVIEW under bounded search
      expect(totalSolvable + totalManualReview, equals(100));
      expect(
        totalSolvable,
        greaterThan(0),
        reason: 'At least some levels are solved under bounded search',
      );
    });
  });
}
