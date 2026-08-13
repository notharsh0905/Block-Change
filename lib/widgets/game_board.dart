import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/tile_model.dart';
import 'game_tile.dart';

/// Centered responsive grid container for rendering the active puzzle board.
class GameBoardWidget extends StatelessWidget {
  final List<List<TileModel>> board;
  final Function(int row, int col) onTileTap;

  const GameBoardWidget({
    super.key,
    required this.board,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    if (board.isEmpty || board.first.isEmpty) {
      return const SizedBox.shrink();
    }

    final gridSize = board.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate max square board size that fits available viewport constraints
        final maxAvailableDimension = math.min(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        // Calculate individual square tile size
        final double tileSize = (maxAvailableDimension / gridSize) - 6.0;

        return SizedBox(
          width: maxAvailableDimension,
          height: maxAvailableDimension,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(gridSize, (r) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(gridSize, (c) {
                  final tile = board[r][c];
                  return GameTileWidget(
                    key: ValueKey('tile_${r}_$c'),
                    tile: tile,
                    tileSize: tileSize,
                    onTap: () => onTileTap(r, c),
                  );
                }),
              );
            }),
          ),
        );
      },
    );
  }
}
