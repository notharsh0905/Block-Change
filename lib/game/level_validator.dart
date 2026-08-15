import 'dart:collection';

import '../config/game_config.dart';
import '../models/level_model.dart';
import '../models/tile_model.dart';
import 'game_rules.dart';
import 'tile_manager.dart';

/// Validation error report detail.
class LevelValidationError {
  final String field;
  final String message;

  const LevelValidationError(this.field, this.message);

  @override
  String toString() => '$field: $message';
}

/// Solver analysis result detail.
class SolverResult {
  final bool isSolvable;
  final int minMoves;
  final int statesVisited;
  final String
  validationStatus; // 'SOLVABLE', 'UNSOLVABLE', 'NEEDS_MANUAL_REVIEW'

  const SolverResult({
    required this.isSolvable,
    required this.minMoves,
    required this.statesVisited,
    required this.validationStatus,
  });
}

class _SolverNode {
  final List<List<TileModel>> board;
  final int moves;

  const _SolverNode({required this.board, required this.moves});
}

/// Level Data Integrity, Schema Validator, & Bounded Puzzle Solver.
abstract class LevelValidator {
  /// Validates a level model definition against non-negotiable PRD constraints.
  static List<LevelValidationError> validateLevel(LevelModel level) {
    final errors = <LevelValidationError>[];

    // Grid size boundary check (PRD 2.1: 3x3 to 8x8)
    if (level.gridSize < GameConfig.minGridSize ||
        level.gridSize > GameConfig.maxGridSize) {
      errors.add(
        LevelValidationError(
          'gridSize',
          'Grid size ${level.gridSize} must be between ${GameConfig.minGridSize} and ${GameConfig.maxGridSize}.',
        ),
      );
    }

    // Color count boundary check
    if (level.colorCount < GameConfig.minColorCount ||
        level.colorCount > GameConfig.maxColorCount) {
      errors.add(
        LevelValidationError(
          'colorCount',
          'Color count ${level.colorCount} must be between ${GameConfig.minColorCount} and ${GameConfig.maxColorCount}.',
        ),
      );
    }

    // Target color boundary check
    if (level.targetColor < 0 || level.targetColor >= level.colorCount) {
      errors.add(
        LevelValidationError(
          'targetColor',
          'Target color index ${level.targetColor} must be valid index within 0..${level.colorCount - 1}.',
        ),
      );
    }

    // Board dimension check
    if (level.initialBoard.length != level.gridSize) {
      errors.add(
        LevelValidationError(
          'initialBoard',
          'Initial board row count ${level.initialBoard.length} does not match gridSize ${level.gridSize}.',
        ),
      );
    } else {
      for (int r = 0; r < level.gridSize; r++) {
        if (level.initialBoard[r].length != level.gridSize) {
          errors.add(
            LevelValidationError(
              'initialBoard',
              'Initial board row $r length ${level.initialBoard[r].length} does not match gridSize ${level.gridSize}.',
            ),
          );
        }
      }
    }

    // Special tiles coordinate check
    for (final st in level.specialTiles) {
      if (st.row < 0 ||
          st.row >= level.gridSize ||
          st.column < 0 ||
          st.column >= level.gridSize) {
        errors.add(
          LevelValidationError(
            'specialTiles',
            'Special tile (${st.row}, ${st.column}) out of grid bounds for size ${level.gridSize}.',
          ),
        );
      }
    }

    return errors;
  }

  /// Builds a complete 2D TileModel board matrix from authored LevelModel definition.
  static List<List<TileModel>> buildBoardFromLevel(LevelModel level) {
    final board = <List<TileModel>>[];
    final specialMap = <String, TileDefinition>{};

    for (final st in level.specialTiles) {
      specialMap['${st.row}_${st.column}'] = st;
    }

    for (int r = 0; r < level.gridSize; r++) {
      final row = <TileModel>[];
      for (int c = 0; c < level.gridSize; c++) {
        final colorIndex = level.initialBoard[r][c];
        final key = '${r}_$c';
        final st = specialMap[key];

        if (st != null) {
          row.add(
            TileModel(
              row: r,
              col: c,
              colorIndex: colorIndex,
              type: st.type,
              lockRemainingSeconds: st.type == TileType.lock
                  ? st.lockDuration
                  : 0.0,
            ),
          );
        } else {
          row.add(
            TileModel(
              row: r,
              col: c,
              colorIndex: colorIndex,
              type: TileType.normal,
            ),
          );
        }
      }
      board.add(row);
    }

    return board;
  }

  /// Bounded BFS Solver to mathematically prove solvability of authored levels.
  ///
  /// Prevents infinite loops and memory exhaustion by capping max search states to [maxStates].
  static SolverResult solveLevel(LevelModel level, {int maxStates = 4000}) {
    final initialBoard = buildBoardFromLevel(level);

    if (GameRules.checkWin(initialBoard, level.targetColor)) {
      return const SolverResult(
        isSolvable: true,
        minMoves: 0,
        statesVisited: 1,
        validationStatus: 'SOLVABLE',
      );
    }

    String serializeState(List<List<TileModel>> b) {
      final sb = StringBuffer();
      for (final r in b) {
        for (final t in r) {
          sb.write('${t.colorIndex}_${t.isLocked ? 1 : 0}_');
        }
      }
      return sb.toString();
    }

    List<List<TileModel>> cloneBoard(List<List<TileModel>> b) {
      return b
          .map((row) => row.map((tile) => tile.copyWith()).toList())
          .toList();
    }

    final queue = Queue<_SolverNode>();
    final visited = <String>{};

    final rootKey = serializeState(initialBoard);
    queue.add(_SolverNode(board: initialBoard, moves: 0));
    visited.add(rootKey);

    int statesVisited = 0;

    while (queue.isNotEmpty && statesVisited < maxStates) {
      final current = queue.removeFirst();
      statesVisited++;

      final gridSize = level.gridSize;

      final coords = <(int, int)>[];
      // Put special tiles first in search order
      for (int r = 0; r < gridSize; r++) {
        for (int c = 0; c < gridSize; c++) {
          if (current.board[r][c].type != TileType.normal) {
            coords.add((r, c));
          }
        }
      }
      for (int r = 0; r < gridSize; r++) {
        for (int c = 0; c < gridSize; c++) {
          if (current.board[r][c].type == TileType.normal) {
            coords.add((r, c));
          }
        }
      }

      for (final (r, c) in coords) {
        final tile = current.board[r][c];

        // 1. Simulate lock expiration (waiting 5s in gameplay unlocks the tile)
        if (tile.isLocked) {
          final unlockedBoard = cloneBoard(current.board);
          unlockedBoard[r][c] = tile.copyWith(lockRemainingSeconds: 0.0);
          final key = serializeState(unlockedBoard);
          if (!visited.contains(key)) {
            visited.add(key);
            queue.add(_SolverNode(board: unlockedBoard, moves: current.moves));
          }
          continue;
        }

        final res = TileManager.tapTile(
          board: current.board,
          row: r,
          col: c,
          colorCount: level.colorCount,
        );

        if (!res.isTileChanged &&
            !res.isBombExploded &&
            !res.isFreezeTriggered) {
          continue;
        }

        if (GameRules.checkWin(res.newBoard, level.targetColor)) {
          return SolverResult(
            isSolvable: true,
            minMoves: current.moves + 1,
            statesVisited: statesVisited,
            validationStatus: 'SOLVABLE',
          );
        }

        final key = serializeState(res.newBoard);
        if (!visited.contains(key)) {
          visited.add(key);
          queue.add(_SolverNode(board: res.newBoard, moves: current.moves + 1));
        }
      }
    }

    if (statesVisited >= maxStates) {
      return SolverResult(
        isSolvable: false,
        minMoves: -1,
        statesVisited: statesVisited,
        validationStatus: 'NEEDS_MANUAL_REVIEW',
      );
    }

    return SolverResult(
      isSolvable: false,
      minMoves: -1,
      statesVisited: statesVisited,
      validationStatus: 'UNSOLVABLE',
    );
  }
}
