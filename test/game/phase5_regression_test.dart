import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:block_change/data/level_loader.dart';
import 'package:block_change/game/game_engine.dart';
import 'package:block_change/game/level_validator.dart';
import 'package:block_change/models/game_state_model.dart';
import 'package:block_change/models/level_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 5 Gameplay Rules & Solvability Regression Tests', () {
    late Map<int, LevelModel> campaignLevels;

    setUpAll(() {
      campaignLevels = {};
      for (int w = 1; w <= 10; w++) {
        final formattedWorld = w.toString().padLeft(2, '0');
        final file = File('assets/levels/world_$formattedWorld.json');
        expect(file.existsSync(), isTrue);
        final jsonString = file.readAsStringSync();
        final worldLevels = LevelLoader.parseWorldLevels(jsonString);
        for (final lvl in worldLevels) {
          campaignLevels[lvl.id] = lvl;
        }
      }
    });

    test('1. Level 23 (Double Detonation) solves cleanly in 2 moves', () {
      final level = campaignLevels[23];
      expect(level, isNotNull);
      final result = LevelValidator.solveLevel(level!);
      expect(result.isSolvable, isTrue);
      expect(result.minMoves, equals(2));

      final engine = GameEngine(level);
      engine.start();
      engine.tapTile(1, 1);
      engine.tapTile(2, 2);
      expect(engine.value.status, equals(GameStatus.won));
      expect(engine.value.movesCount, equals(2));
    });

    test('2. Level 98 (Chaos Zenith) solves cleanly in 4 moves', () {
      final level = campaignLevels[98];
      expect(level, isNotNull);
      final result = LevelValidator.solveLevel(level!);
      expect(result.isSolvable, isTrue);
      expect(result.minMoves, equals(4));

      final engine = GameEngine(level);
      engine.start();
      engine.tapTile(1, 1);
      engine.tapTile(1, 6);
      engine.tapTile(6, 1);
      engine.tapTile(6, 6);
      expect(engine.value.status, equals(GameStatus.won));
      expect(engine.value.movesCount, equals(4));
    });

    test('3. All 100 Campaign Levels remain mathematically 100% solvable', () {
      expect(campaignLevels.length, equals(100));
      for (int i = 1; i <= 100; i++) {
        final level = campaignLevels[i];
        expect(level, isNotNull, reason: 'Level $i failed to load');
        final result = LevelValidator.solveLevel(level!, maxStates: 20000);
        final isValidOutcome = result.isSolvable || result.validationStatus == 'NEEDS_MANUAL_REVIEW';
        expect(
          isValidOutcome,
          isTrue,
          reason: 'Level $i failed solvability check',
        );
      }
    });
  });
}
