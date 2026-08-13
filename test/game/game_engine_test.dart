import 'package:flutter_test/flutter_test.dart';
import 'package:block_change/game/game_engine.dart';
import 'package:block_change/game/game_rules.dart';

import 'package:block_change/models/game_state_model.dart';
import 'package:block_change/models/level_model.dart';
import 'package:block_change/models/tile_model.dart';

void main() {
  group('GameEngine & Game Logic Mechanics Tests', () {
    late LevelModel basicLevel;
    late LevelModel bombLevel;
    late LevelModel lockLevel;
    late LevelModel freezeLevel;
    late LevelModel chaosLevel;

    setUp(() {
      basicLevel = const LevelModel(
        id: 1,
        worldId: 1,
        name: 'Test Level 1',
        gridSize: 3,
        colorCount: 3,
        targetColor: 0,
        initialBoard: [
          [0, 1, 2],
          [2, 0, 1],
          [1, 2, 0],
        ],
        specialTiles: [],
        timeLimitSeconds: 60.0,
        chaosConfig: ChaosConfig(enabled: false),
        starRules: StarRules(
          threeStarMaxMoves: 10,
          threeStarMinRemainingSeconds: 30.0,
          twoStarMaxMoves: 20,
          twoStarMinRemainingSeconds: 15.0,
        ),
        seed: 42,
        difficulty: Difficulty.easy,
      );

      bombLevel = const LevelModel(
        id: 2,
        worldId: 1,
        name: 'Bomb Test Level',
        gridSize: 3,
        colorCount: 3,
        targetColor: 0,
        initialBoard: [
          [1, 1, 1],
          [1, 2, 1],
          [1, 1, 1],
        ],
        specialTiles: [TileDefinition(row: 1, column: 1, type: TileType.bomb)],
        timeLimitSeconds: 60.0,
        chaosConfig: ChaosConfig(enabled: false),
        starRules: StarRules(
          threeStarMaxMoves: 5,
          threeStarMinRemainingSeconds: 30.0,
          twoStarMaxMoves: 10,
          twoStarMinRemainingSeconds: 15.0,
        ),
        seed: 42,
        difficulty: Difficulty.easy,
      );

      lockLevel = const LevelModel(
        id: 3,
        worldId: 1,
        name: 'Lock Test Level',
        gridSize: 3,
        colorCount: 3,
        targetColor: 0,
        initialBoard: [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0],
        ],
        specialTiles: [
          TileDefinition(
            row: 1,
            column: 1,
            type: TileType.lock,
            lockDuration: 3.0,
          ),
        ],
        timeLimitSeconds: 60.0,
        chaosConfig: ChaosConfig(enabled: false),
        starRules: StarRules(
          threeStarMaxMoves: 5,
          threeStarMinRemainingSeconds: 30.0,
          twoStarMaxMoves: 10,
          twoStarMinRemainingSeconds: 15.0,
        ),
        seed: 42,
        difficulty: Difficulty.easy,
      );

      freezeLevel = const LevelModel(
        id: 4,
        worldId: 1,
        name: 'Freeze Test Level',
        gridSize: 3,
        colorCount: 3,
        targetColor: 0,
        initialBoard: [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0],
        ],
        specialTiles: [
          TileDefinition(row: 1, column: 1, type: TileType.freeze),
        ],
        timeLimitSeconds: 60.0,
        chaosConfig: ChaosConfig(enabled: true, initialInterval: 1.0),
        starRules: StarRules(
          threeStarMaxMoves: 5,
          threeStarMinRemainingSeconds: 30.0,
          twoStarMaxMoves: 10,
          twoStarMinRemainingSeconds: 15.0,
        ),
        seed: 42,
        difficulty: Difficulty.easy,
      );

      chaosLevel = const LevelModel(
        id: 5,
        worldId: 1,
        name: 'Chaos Test Level',
        gridSize: 3,
        colorCount: 3,
        targetColor: 0,
        initialBoard: [
          [1, 2, 1],
          [2, 1, 2],
          [1, 2, 1],
        ],
        specialTiles: [],
        timeLimitSeconds: 60.0,
        chaosConfig: ChaosConfig(enabled: true, initialInterval: 1.0),
        starRules: StarRules(
          threeStarMaxMoves: 5,
          threeStarMinRemainingSeconds: 30.0,
          twoStarMaxMoves: 10,
          twoStarMinRemainingSeconds: 15.0,
        ),
        seed: 12345,
        difficulty: Difficulty.easy,
      );
    });

    test('1. Normal tile color cycling', () {
      final engine = GameEngine(basicLevel);
      engine.start();

      expect(engine.value.board[0][0].colorIndex, 0);
      engine.tapTile(0, 0); // 0 -> 1
      expect(engine.value.board[0][0].colorIndex, 1);
      engine.tapTile(0, 0); // 1 -> 2
      expect(engine.value.board[0][0].colorIndex, 2);
      engine.tapTile(0, 0); // 2 -> 0 (cycles back for 3 colors)
      expect(engine.value.board[0][0].colorIndex, 0);
    });

    test('2. Bomb 3x3 behavior', () {
      final engine = GameEngine(bombLevel);
      engine.start();

      // Center (1,1) is bomb with color 2; surrounding tiles are color 1
      expect(engine.value.board[1][1].type, TileType.bomb);
      expect(engine.value.board[1][1].colorIndex, 2);

      engine.tapTile(1, 1);

      // Entire 3x3 neighborhood should now be color 2
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
          expect(engine.value.board[r][c].colorIndex, 2);
        }
      }
    });

    test('3. Bomb boundary behavior at corners', () {
      const cornerBombLevel = LevelModel(
        id: 6,
        worldId: 1,
        name: 'Corner Bomb Level',
        gridSize: 3,
        colorCount: 3,
        targetColor: 0,
        initialBoard: [
          [1, 0, 0],
          [0, 0, 0],
          [0, 0, 0],
        ],
        specialTiles: [TileDefinition(row: 0, column: 0, type: TileType.bomb)],
        timeLimitSeconds: 60.0,
        chaosConfig: ChaosConfig(enabled: false),
        starRules: StarRules(
          threeStarMaxMoves: 5,
          threeStarMinRemainingSeconds: 30.0,
          twoStarMaxMoves: 10,
          twoStarMinRemainingSeconds: 15.0,
        ),
        seed: 42,
        difficulty: Difficulty.easy,
      );

      final engine = GameEngine(cornerBombLevel);
      engine.start();

      // Bomb at top-left corner (0,0) with color 1
      engine.tapTile(0, 0);

      // Affected neighborhood: (0,0), (0,1), (1,0), (1,1)
      expect(engine.value.board[0][0].colorIndex, 1);
      expect(engine.value.board[0][1].colorIndex, 1);
      expect(engine.value.board[1][0].colorIndex, 1);
      expect(engine.value.board[1][1].colorIndex, 1);

      // Unaffected outside neighborhood
      expect(engine.value.board[2][2].colorIndex, 0);
    });

    test('4. Lock prevents direct modification', () {
      final engine = GameEngine(lockLevel);
      engine.start();

      final lockedTile = engine.value.board[1][1];
      expect(lockedTile.isLocked, isTrue);
      expect(lockedTile.colorIndex, 1);

      // Tapping locked tile must be ignored
      engine.tapTile(1, 1);
      expect(engine.value.board[1][1].colorIndex, 1);
      expect(engine.value.movesCount, 0);
    });

    test('5. Lock expires correctly over ticks', () {
      final engine = GameEngine(lockLevel);
      engine.start();

      expect(engine.value.board[1][1].isLocked, isTrue);

      // Tick 2 seconds (duration is 3s)
      engine.update(2.0);
      expect(engine.value.board[1][1].isLocked, isTrue);

      // Tick 1.5 seconds more (total 3.5s > 3.0s)
      engine.update(1.5);
      expect(engine.value.board[1][1].isLocked, isFalse);
      expect(engine.value.board[1][1].type, TileType.normal);

      // Now tile can be tapped and modified normally
      engine.tapTile(1, 1);
      expect(engine.value.board[1][1].colorIndex, 2);
    });

    test('6. Freeze pauses chaos progression', () {
      final engine = GameEngine(freezeLevel);
      engine.start();

      // Tap freeze tile at (1,1)
      engine.tapTile(1, 1);
      expect(engine.value.isFrozen, isTrue);
      expect(engine.value.freezeRemainingSeconds, 3.0);

      final boardBeforeTick = engine.value.board;

      // Update 2.0s while frozen (chaos interval is 1.0s)
      engine.update(2.0);

      // Board should NOT change because chaos is frozen
      expect(engine.value.isFrozen, isTrue);
      expect(engine.value.chaosTimerSeconds, 0.0);
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
          expect(
            engine.value.board[r][c].colorIndex,
            equals(boardBeforeTick[r][c].colorIndex),
          );
        }
      }
    });

    test('7. Freeze expires correctly', () {
      final engine = GameEngine(freezeLevel);
      engine.start();

      // Trigger freeze (3.0s duration)
      engine.tapTile(1, 1);
      expect(engine.value.isFrozen, isTrue);

      // Update 3.5s
      engine.update(3.5);
      expect(engine.value.isFrozen, isFalse);
      expect(engine.value.freezeRemainingSeconds, 0.0);
    });

    test('8. Chaos changes tiles when active', () {
      final engine = GameEngine(chaosLevel);
      engine.start();

      final initialBoard = engine.value.board;

      // Update by chaos interval (1.0s)
      engine.update(1.0);

      // One tile on the board should have mutated
      bool mutated = false;
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
          if (engine.value.board[r][c].colorIndex !=
              initialBoard[r][c].colorIndex) {
            mutated = true;
            break;
          }
        }
      }

      expect(mutated, isTrue);
    });

    test('9. Win detection when all tiles equal target color', () {
      const winableLevel = LevelModel(
        id: 7,
        worldId: 1,
        name: 'Winable Level',
        gridSize: 2,
        colorCount: 3,
        targetColor: 0,
        initialBoard: [
          [0, 0],
          [0, 1],
        ],

        specialTiles: [],
        timeLimitSeconds: 60.0,
        chaosConfig: ChaosConfig(enabled: false),
        starRules: StarRules(
          threeStarMaxMoves: 5,
          threeStarMinRemainingSeconds: 30.0,
          twoStarMaxMoves: 10,
          twoStarMinRemainingSeconds: 15.0,
        ),
        seed: 42,
        difficulty: Difficulty.easy,
      );

      final engine = GameEngine(winableLevel);
      engine.start();

      expect(engine.value.status, GameStatus.playing);

      // Tap (1,1) twice to cycle 2 -> 0 -> match target 0
      engine.tapTile(1, 1);
      expect(engine.value.status, GameStatus.playing);

      engine.tapTile(1, 1);
      expect(engine.value.status, GameStatus.won);
    });

    test('10. Non-winning board detection when tiles differ', () {
      final engine = GameEngine(basicLevel);
      engine.start();

      expect(
        GameRules.checkWin(engine.value.board, engine.value.targetColor),
        isFalse,
      );
      expect(engine.value.status, GameStatus.playing);
    });

    test('11. Timer countdown decrements time remaining', () {
      final engine = GameEngine(basicLevel);
      engine.start();

      expect(engine.value.timeRemainingSeconds, 60.0);
      engine.update(5.5);
      expect(engine.value.timeRemainingSeconds, 54.5);
    });

    test('12. Pause and resume behavior', () {
      final engine = GameEngine(basicLevel);
      engine.start();
      expect(engine.value.status, GameStatus.playing);

      engine.pause();
      expect(engine.value.status, GameStatus.paused);

      // Ticks should be ignored while paused
      engine.update(10.0);
      expect(engine.value.timeRemainingSeconds, 60.0);

      engine.resume();
      expect(engine.value.status, GameStatus.playing);

      engine.update(2.0);
      expect(engine.value.timeRemainingSeconds, 58.0);
    });

    test('13. Restart resets level board, timer, and moves', () {
      final engine = GameEngine(basicLevel);
      engine.start();

      engine.tapTile(0, 0);
      engine.update(10.0);

      expect(engine.value.movesCount, 1);
      expect(engine.value.timeRemainingSeconds, 50.0);

      engine.restart();

      expect(engine.value.status, GameStatus.playing);
      expect(engine.value.movesCount, 0);
      expect(engine.value.timeRemainingSeconds, 60.0);
      expect(engine.value.board[0][0].colorIndex, 0);
    });

    test('14. Deterministic seed produces reproducible behavior', () {
      final engine1 = GameEngine(chaosLevel, seed: 9999);
      final engine2 = GameEngine(chaosLevel, seed: 9999);

      engine1.start();
      engine2.start();

      engine1.update(1.0);
      engine2.update(1.0);

      // Both boards after 1s tick with same seed MUST be identical
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
          expect(
            engine1.value.board[r][c].colorIndex,
            equals(engine2.value.board[r][c].colorIndex),
          );
        }
      }
    });
  });
}
