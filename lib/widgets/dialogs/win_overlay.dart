import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../game_button.dart';

/// Level Completion victory overlay dialog with sequential star pop animation.
class WinOverlay extends StatefulWidget {
  final int levelNumber;
  final int score;
  final int moves;
  final int stars;
  final VoidCallback onNextLevel;
  final VoidCallback onReplay;

  const WinOverlay({
    super.key,
    required this.levelNumber,
    required this.score,
    required this.moves,
    required this.stars,
    required this.onNextLevel,
    required this.onReplay,
  });

  @override
  State<WinOverlay> createState() => _WinOverlayState();
}

class _WinOverlayState extends State<WinOverlay> with TickerProviderStateMixin {
  late AnimationController _animController;
  final List<Animation<double>> _starScales = [];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    for (int i = 0; i < 3; i++) {
      final start = (i * 0.2).clamp(0.0, 0.6);
      final end = (start + 0.4).clamp(0.0, 1.0);
      _starScales.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          ),
        ),
      );
    }

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceElevated,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉 LEVEL COMPLETE!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.sunshine,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Level ${widget.levelNumber}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Sequential Animated Star Rating Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isEarned = index < widget.stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ScaleTransition(
                    scale: _starScales[index],
                    child: Icon(
                      isEarned
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: isEarned
                          ? AppColors.sunshine
                          : AppColors.textSecondary.withValues(alpha: 0.5),
                      size: 48,
                      shadows: isEarned
                          ? const [
                              Shadow(
                                color: Color(0xFFD49B00),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Performance stats
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(label: 'MOVES', value: '${widget.moves}'),
                  _StatItem(label: 'SCORE', value: '${widget.score}'),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Action Buttons
            GameButton(
              label: 'NEXT LEVEL',
              icon: Icons.arrow_forward_rounded,
              color: AppColors.mint,
              darkColor: AppColors.mintDark,
              onPressed: widget.onNextLevel,
            ),
            const SizedBox(height: 12),
            GameButton(
              label: 'REPLAY',
              icon: Icons.refresh_rounded,
              color: AppColors.sky,
              darkColor: AppColors.skyDark,
              onPressed: widget.onReplay,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
