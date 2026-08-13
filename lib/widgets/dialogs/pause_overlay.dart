import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../game_button.dart';

/// Pause menu dialog overlay.
class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceElevated,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME PAUSED',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.black,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            GameButton(
              label: 'RESUME',
              icon: Icons.play_arrow_rounded,
              color: AppColors.mint,
              darkColor: AppColors.mintDark,
              onPressed: onResume,
            ),
            const SizedBox(height: 12),
            GameButton(
              label: 'RESTART',
              icon: Icons.refresh_rounded,
              color: AppColors.sky,
              darkColor: AppColors.skyDark,
              onPressed: onRestart,
            ),
            const SizedBox(height: 12),
            GameButton(
              label: 'EXIT TO HOME',
              icon: Icons.home_rounded,
              color: AppColors.surface,
              darkColor: const Color(0xFF191924),
              onPressed: onExit,
            ),
          ],
        ),
      ),
    );
  }
}
