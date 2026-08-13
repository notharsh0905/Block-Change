import '../models/tile_model.dart';

/// Pure functions for core game rules and win condition evaluations.
abstract class GameRules {
  /// Cycles a color index through available colors [0..colorCount - 1].
  static int cycleColor(int currentColor, int colorCount) {
    if (colorCount <= 0) return 0;
    return (currentColor + 1) % colorCount;
  }

  /// Determines if the board satisfies the level completion win condition.
  ///
  /// Win condition: EVERY cell in the grid must equal [targetColor].
  static bool checkWin(List<List<TileModel>> board, int targetColor) {
    if (board.isEmpty || board.first.isEmpty) return false;

    for (final row in board) {
      for (final tile in row) {
        if (tile.colorIndex != targetColor) {
          return false;
        }
      }
    }
    return true;
  }

  /// Calculates the fraction of tiles on the board matching [targetColor].
  static double calculateSimilarityRatio(
    List<List<TileModel>> board,
    int targetColor,
  ) {
    if (board.isEmpty || board.first.isEmpty) return 0.0;

    int matchCount = 0;
    int totalTiles = 0;

    for (final row in board) {
      for (final tile in row) {
        totalTiles++;
        if (tile.colorIndex == targetColor) {
          matchCount++;
        }
      }
    }

    return totalTiles == 0 ? 0.0 : matchCount / totalTiles;
  }
}
