import '../models/tile_model.dart';
import 'game_rules.dart';

/// Interaction result detailing affected board and special mechanics triggered.
class TileTapResult {
  final List<List<TileModel>> newBoard;
  final bool isFreezeTriggered;
  final double freezeDurationSeconds;
  final bool isBombExploded;
  final bool isTileChanged;

  const TileTapResult({
    required this.newBoard,
    this.isFreezeTriggered = false,
    this.freezeDurationSeconds = 0.0,
    this.isBombExploded = false,
    this.isTileChanged = false,
  });
}

/// Domain manager handling tile interaction mechanics and special tile behaviors.
abstract class TileManager {
  /// Handles player tap interaction on tile at ([row], [col]).
  static TileTapResult tapTile({
    required List<List<TileModel>> board,
    required int row,
    required int col,
    required int colorCount,
    double defaultFreezeDuration = 3.0,
  }) {
    if (row < 0 || row >= board.length || col < 0 || col >= board[row].length) {
      return TileTapResult(newBoard: board);
    }

    final targetTile = board[row][col];

    // Locked tile cannot be directly tapped
    if (targetTile.isLocked) {
      return TileTapResult(newBoard: board);
    }

    switch (targetTile.type) {
      case TileType.bomb:
        final newBoard = applyBombExplosion(
          board: board,
          centerRow: row,
          centerCol: col,
        );
        return TileTapResult(
          newBoard: newBoard,
          isBombExploded: true,
          isTileChanged: true,
        );

      case TileType.freeze:
        // Freeze tile activates freeze timer and cycles tile color
        final newColor = GameRules.cycleColor(
          targetTile.colorIndex,
          colorCount,
        );
        final newBoard = _cloneBoard(board);
        newBoard[row][col] = targetTile.copyWith(colorIndex: newColor);
        return TileTapResult(
          newBoard: newBoard,
          isFreezeTriggered: true,
          freezeDurationSeconds: defaultFreezeDuration,
          isTileChanged: true,
        );

      case TileType.lock:
        // Locked tile cannot be tapped if locked
        if (targetTile.lockRemainingSeconds > 0.0) {
          return TileTapResult(newBoard: board);
        }
        final newColor = GameRules.cycleColor(
          targetTile.colorIndex,
          colorCount,
        );
        final newBoard = _cloneBoard(board);
        newBoard[row][col] = targetTile.copyWith(colorIndex: newColor);
        return TileTapResult(newBoard: newBoard, isTileChanged: true);

      case TileType.normal:
        final newColor = GameRules.cycleColor(
          targetTile.colorIndex,
          colorCount,
        );
        final newBoard = _cloneBoard(board);
        newBoard[row][col] = targetTile.copyWith(colorIndex: newColor);
        return TileTapResult(newBoard: newBoard, isTileChanged: true);
    }
  }

  /// Applies 3x3 bomb explosion setting valid non-locked neighboring tiles to bomb's color.
  static List<List<TileModel>> applyBombExplosion({
    required List<List<TileModel>> board,
    required int centerRow,
    required int centerCol,
  }) {
    final newBoard = _cloneBoard(board);
    final bombColor = board[centerRow][centerCol].colorIndex;

    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        final r = centerRow + dr;
        final c = centerCol + dc;

        if (r >= 0 && r < board.length && c >= 0 && c < board[r].length) {
          final tile = newBoard[r][c];

          // PRD Rule: Locked tiles are NOT changed by bomb explosions
          if (!tile.isLocked) {
            newBoard[r][c] = tile.copyWith(colorIndex: bombColor);
          }
        }
      }
    }
    return newBoard;
  }

  /// Helper to create a deep mutable copy of 2D board matrix.
  static List<List<TileModel>> _cloneBoard(List<List<TileModel>> board) {
    return board
        .map((row) => row.map((tile) => tile.copyWith()).toList())
        .toList();
  }
}
