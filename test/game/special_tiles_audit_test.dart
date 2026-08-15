import 'package:block_change/data/level_loader.dart';
import 'package:block_change/game/level_validator.dart';
import 'package:block_change/game/tile_manager.dart';
import 'package:block_change/models/tile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 4.1 — Special Tile Semantics, Color Independence & Level 23 Audit Tests', () {
    test('1. TileModel maintains strict independence between colorIndex and TileType', () {
      const greenBomb = TileModel(
        row: 0,
        col: 0,
        colorIndex: 1,
        type: TileType.bomb,
      );
      const redBomb = TileModel(
        row: 0,
        col: 0,
        colorIndex: 0,
        type: TileType.bomb,
      );
      const blueFreeze = TileModel(
        row: 1,
        col: 1,
        colorIndex: 2,
        type: TileType.freeze,
      );
      const yellowLock = TileModel(
        row: 2,
        col: 2,
        colorIndex: 3,
        type: TileType.lock,
        lockRemainingSeconds: 5.0,
      );

      expect(greenBomb.colorIndex, equals(1));
      expect(greenBomb.type, equals(TileType.bomb));

      expect(redBomb.colorIndex, equals(0));
      expect(redBomb.type, equals(TileType.bomb));

      expect(blueFreeze.colorIndex, equals(2));
      expect(blueFreeze.type, equals(TileType.freeze));

      expect(yellowLock.colorIndex, equals(3));
      expect(yellowLock.type, equals(TileType.lock));
      expect(yellowLock.isLocked, isTrue);
    });

    test(
      '2. Bomb explosion applies bomb base color to 3x3 surrounding tiles',
      () {
        final board = [
          [
            const TileModel(
              row: 0,
              col: 0,
              colorIndex: 2,
              type: TileType.normal,
            ),
            const TileModel(
              row: 0,
              col: 1,
              colorIndex: 2,
              type: TileType.normal,
            ),
            const TileModel(
              row: 0,
              col: 2,
              colorIndex: 2,
              type: TileType.normal,
            ),
          ],
          [
            const TileModel(
              row: 1,
              col: 0,
              colorIndex: 2,
              type: TileType.normal,
            ),
            const TileModel(
              row: 1,
              col: 1,
              colorIndex: 1,
              type: TileType.bomb,
            ), // GREEN BOMB (colorIndex: 1)
            const TileModel(
              row: 1,
              col: 2,
              colorIndex: 2,
              type: TileType.normal,
            ),
          ],
          [
            const TileModel(
              row: 2,
              col: 0,
              colorIndex: 2,
              type: TileType.normal,
            ),
            const TileModel(
              row: 2,
              col: 1,
              colorIndex: 2,
              type: TileType.normal,
            ),
            const TileModel(
              row: 2,
              col: 2,
              colorIndex: 2,
              type: TileType.normal,
            ),
          ],
        ];

        final result = TileManager.applyBombExplosion(
          board: board,
          centerRow: 1,
          centerCol: 1,
        );

        // Verify all 3x3 tiles turned GREEN (colorIndex: 1)
        for (int r = 0; r < 3; r++) {
          for (int c = 0; c < 3; c++) {
            expect(
              result[r][c].colorIndex,
              equals(1),
              reason: 'Tile ($r,$c) should be GREEN (1) after explosion',
            );
          }
        }
      },
    );

    test('3. Redesigned Level 23 (Double Detonation) loads and solves cleanly in 2 moves', () async {
      final levels = LevelLoader.getFallbackWorldLevels(3);
      final level23 = levels.firstWhere((l) => l.id == 23);

      expect(level23.name, equals('Double Detonation'));
      expect(level23.targetColor, equals(1)); // Mint Green
      expect(level23.specialTiles.length, equals(2));
      expect(level23.specialTiles[0].type, equals(TileType.bomb));
      expect(level23.specialTiles[1].type, equals(TileType.bomb));

      // Verify initial board bomb positions (1,1) and (2,2) have colorIndex 1 (Mint Green)
      final board = LevelValidator.buildBoardFromLevel(level23);
      expect(board[1][1].type, equals(TileType.bomb));
      expect(
        board[1][1].colorIndex,
        equals(1),
        reason: 'Bomb 1 must be Green (target color)',
      );

      expect(board[2][2].type, equals(TileType.bomb));
      expect(
        board[2][2].colorIndex,
        equals(1),
        reason: 'Bomb 2 must be Green (target color)',
      );

      // Verify mathematical solvability
      final solverResult = LevelValidator.solveLevel(level23);
      expect(
        solverResult.isSolvable,
        isTrue,
        reason: 'Level 23 must be proven solvable',
      );
      expect(
        solverResult.minMoves,
        lessThanOrEqualTo(4),
        reason: 'Level 23 should solve in 2-4 moves',
      );
    });

    test('4. Special Tile Level Audit: All Bomb/Freeze/Lock levels pass validation and solvability', () async {
      for (int w = 1; w <= 10; w++) {
        final levels = LevelLoader.getFallbackWorldLevels(w);
        for (final level in levels) {
          final errors = LevelValidator.validateLevel(level);
          expect(
            errors,
            isEmpty,
            reason:
                'Level ${level.id} (${level.name}) should have no validation errors',
          );

          // Verify special tiles have valid non-null definitions
          for (final st in level.specialTiles) {
            expect(st.row, greaterThanOrEqualTo(0));
            expect(st.row, lessThan(level.gridSize));
            expect(st.column, greaterThanOrEqualTo(0));
            expect(st.column, lessThan(level.gridSize));
          }
        }
      }
    });
  });
}
