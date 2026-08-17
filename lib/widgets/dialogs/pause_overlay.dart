import 'package:flutter/material.dart';

import '../../services/audio_service.dart';
import '../../services/haptic_service.dart';
import '../../theme/app_colors.dart';
import '../game_button.dart';

/// Pause menu dialog overlay with Settings integration.
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME PAUSED',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            GameButton(
              label: 'RESUME',
              icon: Icons.play_arrow_rounded,
              color: AppColors.mint,
              darkColor: AppColors.mintDark,
              onPressed: () {
                AudioService.instance.playButtonTap();
                HapticService.instance.buttonPress();
                onResume();
              },
            ),
            const SizedBox(height: 10),
            GameButton(
              label: 'RESTART',
              icon: Icons.refresh_rounded,
              color: AppColors.sky,
              darkColor: AppColors.skyDark,
              onPressed: () {
                AudioService.instance.playButtonTap();
                HapticService.instance.buttonPress();
                onRestart();
              },
            ),
            const SizedBox(height: 10),
            GameButton(
              label: 'SETTINGS',
              icon: Icons.settings_rounded,
              color: AppColors.violet,
              darkColor: const Color(0xFF6B30C2),
              onPressed: () {
                AudioService.instance.playButtonTap();
                HapticService.instance.buttonPress();
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(height: 10),
            GameButton(
              label: 'EXIT TO HOME',
              icon: Icons.home_rounded,
              color: AppColors.surface,
              darkColor: const Color(0xFF191924),
              onPressed: () {
                AudioService.instance.playButtonTap();
                HapticService.instance.buttonPress();
                onExit();
              },
            ),
          ],
        ),
      ),
    );
  }
}
