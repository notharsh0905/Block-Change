import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/tile_model.dart';
import '../theme/app_colors.dart';

/// Reusable 2.5D interactive block widget with micro-animations.
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
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Scale pop animation for successful taps & changes
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );

    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.90), weight: 45),
        TweenSequenceItem(tween: Tween(begin: 0.90, end: 1.06), weight: 35),
        TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 20),
      ],
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    // Shake animation for locked tile taps
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 20),
          TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 6.0, end: -4.0), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -4.0, end: 0.0), weight: 25),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  @override
  void didUpdateWidget(covariant GameTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger bounce feedback if color or type changed
    if (oldWidget.tile.colorIndex != widget.tile.colorIndex ||
        oldWidget.tile.type != widget.tile.type) {
      _scaleController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.tile.isLocked) {
      _shakeController.forward(from: 0.0);
      return;
    }
    _scaleController.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colorIdx = widget.tile.colorIndex % AppColors.gamePalette.length;
    final baseColor = AppColors.gamePalette[colorIdx];
    final shadowColor = AppColors.gamePaletteDark[colorIdx];
    final isLocked = widget.tile.isLocked;

    final actualColor = isLocked
        ? Color.lerp(baseColor, Colors.black, 0.45)!
        : baseColor;
    final actualShadow = isLocked
        ? Color.lerp(shadowColor, Colors.black, 0.6)!
        : shadowColor;

    final borderRadius = math.max(8.0, widget.tileSize * 0.20);
    final iconSize = math.max(16.0, widget.tileSize * 0.42);

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _shakeAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: Transform.scale(scale: _scaleAnimation.value, child: child),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.tileSize,
          height: widget.tileSize,
          margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: actualColor,
            borderRadius: BorderRadius.circular(borderRadius),
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
              // Top 2.5D highlight edge
              Positioned(
                top: 4,
                left: 6,
                right: 6,
                child: Container(
                  height: math.max(3.0, widget.tileSize * 0.08),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.30),
                    borderRadius: BorderRadius.circular(borderRadius * 0.5),
                  ),
                ),
              ),

              // Tile type indicator icons & badges
              if (widget.tile.type == TileType.bomb)
                Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.sunshine,
                  size: iconSize,
                  shadows: const [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

              if (widget.tile.type == TileType.freeze)
                Icon(
                  Icons.ac_unit_rounded,
                  color: Colors.white,
                  size: iconSize,
                  shadows: const [
                    Shadow(
                      color: Color(0xFF0072D2),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

              if (widget.tile.type == TileType.lock)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: isLocked ? const Color(0xFFFFD200) : Colors.white,
                      size: iconSize * 0.85,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    if (isLocked) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.tile.lockRemainingSeconds.ceil()}s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: math.max(9.0, widget.tileSize * 0.16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
