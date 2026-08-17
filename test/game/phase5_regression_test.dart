import 'package:flutter_test/flutter_test.dart';
import 'package:block_change/data/level_loader.dart';
import 'package:block_change/game/game_engine.dart';
import 'package:block_change/game/level_validator.dart';
import 'package:block_change/models/game_state_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 5 Gameplay Rules & Solvability Regression Tests', () {
    test('1. Level 23 (Double Detonation) solves cleanly in 2 moves', () async {
      final level = await LevelLoader.loadLevelById(23);
      expect(level, isNotNull);
      final result = LevelValidator.solveLevel(level!);
      expect(result.isSolvable, isTrue);
      expect(result.minMoves, equals(2));

      // Test on GameEngine
      final engine = GameEngine(level);
      engine.start();
      engine.tapTile(1, 1);
      engine.tapTile(2, 2);
      expect(engine.value.status, equals(GameStatus.won));
      expect(engine.value.movesCount, equals(2));
    });

    test('2. Level 98 (Chaos Zenith) solves cleanly in 4 moves', () async {
      final level = await LevelLoader.loadLevelById(98);
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

    test('3. All 100 Campaign Levels remain mathematically 100% solvable', () async {
      for (int i = 1; i <= 100; i++) {
        final level = await LevelLoader.loadLevelById(i);
        expect(level, isNotNull, reason: 'Level $i failed to load');
        final result = LevelValidator.solveLevel(level!);
        expect(
          result.isSolvable,
          isTrue,
          reason: 'Level $i failed solvability check',
        );
      }
    });
  });
}
