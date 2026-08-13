import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../game_button.dart';

/// Level Completion victory overlay dialog.
class WinOverlay extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceElevated,
      elevation: 12,
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
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Level $levelNumber',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Star Rating Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isEarned = index < stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Icon(
                    isEarned ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isEarned
                        ? AppColors.sunshine
                        : AppColors.textSecondary,
                    size: 44,
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
                  _StatItem(label: 'MOVES', value: '$moves'),
                  _StatItem(label: 'SCORE', value: '$score'),
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
              onPressed: onNextLevel,
            ),
            const SizedBox(height: 12),
            GameButton(
              label: 'REPLAY',
              icon: Icons.refresh_rounded,
              color: AppColors.sky,
              darkColor: AppColors.skyDark,
              onPressed: onReplay,
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
