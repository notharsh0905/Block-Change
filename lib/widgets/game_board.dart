import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/tile_model.dart';
import '../theme/app_colors.dart';
import 'game_tile.dart';

/// Centered responsive elevated 2.5D grid container for rendering puzzle board.
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

        // Frame padding & border offsets inside elevated board container
        const double framePadding = 12.0;
        const double borderWidth = 2.5;
        const double tileMargin = 3.0;

        final double innerBoardSize = math.max(
          0.0,
          maxAvailableDimension - (framePadding * 2) - (borderWidth * 2) - 4.0,
        );
        final double tileSize = math.max(
          10.0,
          (innerBoardSize / gridSize) - (tileMargin * 2),
        );

        return Container(
          width: maxAvailableDimension,
          height: maxAvailableDimension,
          padding: const EdgeInsets.all(framePadding),
          decoration: BoxDecoration(
            color: AppColors.boardBackground,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: AppColors.boardBorder,
              width: borderWidth,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(0, 8),
                blurRadius: 16,
              ),
            ],
          ),
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
