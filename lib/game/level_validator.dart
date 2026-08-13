import '../config/game_config.dart';
import '../models/level_model.dart';
import '../models/tile_model.dart';

/// Validation error report detail.
class LevelValidationError {
  final String field;
  final String message;

  const LevelValidationError(this.field, this.message);

  @override
  String toString() => '$field: $message';
}

/// Level Data Integrity & Schema Validator.
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
}
