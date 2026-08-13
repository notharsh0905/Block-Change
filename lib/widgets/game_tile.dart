import 'package:flutter/material.dart';
import '../models/tile_model.dart';
import '../theme/app_colors.dart';

/// Reusable 2.5D interactive block widget.
class GameTileWidget extends StatefulWidget {
  final TileModel tile;
  final double tileSize;
  final VoidCallback onTap;

  const GameTileWidget({
    super.key,
    required this.tile,
    required this.tileSize,
    required this.onTap,
  });

  @override
  State<GameTileWidget> createState() => _GameTileWidgetState();
}

class _GameTileWidgetState extends State<GameTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.90), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.90, end: 1.05), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 20),
    ]).animate(_animController);
  }

  @override
  void didUpdateWidget(covariant GameTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger bounce feedback if color or type changed
    if (oldWidget.tile.colorIndex != widget.tile.colorIndex ||
        oldWidget.tile.type != widget.tile.type) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.tile.isLocked) return;
    _animController.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colorIdx = widget.tile.colorIndex % AppColors.gamePalette.length;
    final baseColor = AppColors.gamePalette[colorIdx];
    final shadowColor = AppColors.gamePaletteDark[colorIdx];
    final isLocked = widget.tile.isLocked;

    final actualColor = isLocked ? Color.lerp(baseColor, Colors.black, 0.4)! : baseColor;
    final actualShadow = isLocked ? Color.lerp(shadowColor, Colors.black, 0.5)! : shadowColor;

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.tileSize,
          height: widget.tileSize,
          margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: actualColor,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: actualShadow,
                offset: const Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Top highlight glow
              Positioned(
                top: 4,
                left: 8,
                right: 8,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),

              // Tile type indicator icons
              if (widget.tile.type == TileType.bomb)
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 28,
                ),

              if (widget.tile.type == TileType.freeze)
                const Icon(
                  Icons.ac_unit_rounded,
                  color: Colors.white,
                  size: 28,
                ),

              if (widget.tile.type == TileType.lock)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    if (isLocked)
                      Text(
                        '${widget.tile.lockRemainingSeconds.ceil()}s',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
