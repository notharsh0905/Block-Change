import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/game_button.dart';

/// Playful 2.5D Home Screen dashboard with background decoration.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: Stack(
          children: [
            // Subtle floating decorative background shapes
            Positioned(
              top: -30,
              left: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.violet.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(36),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.sky.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(48),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  children: [
                    const Spacer(),

                    // Multi-color 2.5D Logo Block Motif
                    Container(
                      width: 110,
                      height: 110,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(28.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            offset: Offset(0, 8),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _MiniBlock(
                            color: AppColors.coral,
                            darkColor: AppColors.coralDark,
                          ),
                          _MiniBlock(
                            color: AppColors.mint,
                            darkColor: AppColors.mintDark,
                          ),
                          _MiniBlock(
                            color: AppColors.sky,
                            darkColor: AppColors.skyDark,
                          ),
                          _MiniBlock(
                            color: AppColors.sunshine,
                            darkColor: AppColors.sunshineDark,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'BLOCK CHANGE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.6,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Color Chaos Puzzle Game',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    // Primary Action Buttons
                    GameButton(
                      label: 'START GAME',
                      icon: Icons.play_arrow_rounded,
                      color: AppColors.mint,
                      darkColor: AppColors.mintDark,
                      height: 60,
                      fontSize: 20,
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
                                  content: Text(
                                    'Level Map unlocked in future phase!',
                                  ),
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
                            darkColor: const Color(0xFF222238),
                            fontSize: 15,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Settings unlocked in future phase!',
                                  ),
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
          ],
        ),
      ),
    );
  }
}

class _MiniBlock extends StatelessWidget {
  final Color color;
  final Color darkColor;

  const _MiniBlock({required this.color, required this.darkColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: darkColor,
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
    );
  }
}
