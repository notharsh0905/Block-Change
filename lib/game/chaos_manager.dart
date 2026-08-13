import 'dart:math' as math;

import '../models/tile_model.dart';

/// Result of chaos automatic mutation pass.
class ChaosMutationResult {
  final List<List<TileModel>> newBoard;
  final bool isMutated;
  final int? mutatedRow;
  final int? mutatedCol;

  const ChaosMutationResult({
    required this.newBoard,
    required this.isMutated,
    this.mutatedRow,
    this.mutatedCol,
  });
}

/// Domain manager handling deterministic automatic chaos pressure.
abstract class ChaosManager {
  /// Selects an eligible non-locked cell and alters its logical color.
  static ChaosMutationResult applyChaos({
    required List<List<TileModel>> board,
    required int colorCount,
    required math.Random rng,
  }) {
    if (board.isEmpty || board.first.isEmpty || colorCount <= 1) {
      return ChaosMutationResult(newBoard: board, isMutated: false);
    }

    final eligibleTiles = <TileModel>[];
    for (final row in board) {
      for (final tile in row) {
        if (!tile.isLocked) {
          eligibleTiles.add(tile);
        }
      }
    }

    if (eligibleTiles.isEmpty) {
      return ChaosMutationResult(newBoard: board, isMutated: false);
    }

    // Pick a random eligible cell deterministically
    final target = eligibleTiles[rng.nextInt(eligibleTiles.length)];

    // Select a new color different from current tile color
    int newColor = rng.nextInt(colorCount);
    if (newColor == target.colorIndex) {
      newColor = (newColor + 1) % colorCount;
    }

    // Clone board and apply chaos mutation
    final newBoard = board
        .map((row) => row.map((tile) => tile.copyWith()).toList())
        .toList();

    newBoard[target.row][target.col] = target.copyWith(colorIndex: newColor);

    return ChaosMutationResult(
      newBoard: newBoard,
      isMutated: true,
      mutatedRow: target.row,
      mutatedCol: target.col,
    );
  }
}
