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

    // Target color range check
    if (level.targetColor < 0 || level.targetColor >= level.colorCount) {
      errors.add(
        LevelValidationError(
          'targetColor',
          'Target color index ${level.targetColor} is out of bounds for colorCount ${level.colorCount}.',
        ),
      );
    }

    // Initial board dimension check
    if (level.initialBoard.length != level.gridSize) {
      errors.add(
        LevelValidationError(
          'initialBoard',
          'Initial board row count ${level.initialBoard.length} does not match gridSize ${level.gridSize}.',
        ),
      );
    } else {
      for (int i = 0; i < level.initialBoard.length; i++) {
        if (level.initialBoard[i].length != level.gridSize) {
          errors.add(
            LevelValidationError(
              'initialBoard[$i]',
              'Row $i length ${level.initialBoard[i].length} does not match gridSize ${level.gridSize}.',
            ),
          );
        }
      }
    }

    // Time limit check
    if (level.timeLimitSeconds <= 0.0) {
      errors.add(
        LevelValidationError(
          'timeLimitSeconds',
          'Time limit must be positive.',
        ),
      );
    }

    // Special tiles coordinate check
    for (final tileDef in level.specialTiles) {
      if (tileDef.row < 0 ||
          tileDef.row >= level.gridSize ||
          tileDef.column < 0 ||
          tileDef.column >= level.gridSize) {
        errors.add(
          LevelValidationError(
            'specialTiles',
            'Special tile position (${tileDef.row}, ${tileDef.column}) is outside grid dimensions.',
          ),
        );
      }
    }

    return errors;
  }

  /// Constructs live initial tile board matrix from [LevelModel].
  static List<List<TileModel>> buildBoardFromLevel(LevelModel level) {
    final board = <List<TileModel>>[];

    // Map special tiles lookup
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

    // Serialized state representation string for BFS visited queue
    String serializeState(List<List<TileModel>> b) {
      final sb = StringBuffer();
      for (final r in b) {
        for (final t in r) {
          sb.write('${t.colorIndex}');
        }
      }
      return sb.toString();
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

      for (int r = 0; r < gridSize; r++) {
        for (int c = 0; c < gridSize; c++) {
          final tile = current.board[r][c];
          if (tile.isLocked) continue;
          if (tile.type == TileType.normal &&
              tile.colorIndex == level.targetColor) {
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
            queue.add(
              _SolverNode(board: res.newBoard, moves: current.moves + 1),
            );
          }
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
      validationStatus: 'NEEDS_MANUAL_REVIEW',
    );
  }
}

class _SolverNode {
  final List<List<TileModel>> board;
  final int moves;

  const _SolverNode({required this.board, required this.moves});
}
