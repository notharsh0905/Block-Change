import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/game_button.dart';

/// Playful 2.5D Home Screen dashboard.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              const Spacer(),

              // Logo & Title Motif
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(28.0),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.coralDark,
                      offset: Offset(0, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  size: 64,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'BLOCK CHANGE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.black,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Color Chaos Puzzle Game',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Action Buttons
              GameButton(
                label: 'START GAME',
                icon: Icons.play_arrow_rounded,
                color: AppColors.mint,
                darkColor: AppColors.mintDark,
                onPressed: () {
                  Navigator.pushNamed(context, '/gameplay');
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: GameButton(
                      label: 'MAP',
                      icon: Icons.map_rounded,
                      color: AppColors.sky,
                      darkColor: AppColors.skyDark,
                      fontSize: 15,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Level Map unlocked in future phase!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GameButton(
                      label: 'SETTINGS',
                      icon: Icons.settings_rounded,
                      color: AppColors.surfaceElevated,
                      darkColor: Color(0xFF1E1E2E),
                      fontSize: 15,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Settings unlocked in future phase!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
