import 'package:flutter/material.dart';

import '../data/level_loader.dart';
import '../models/player_progress_model.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_colors.dart';
import '../widgets/game_button.dart';
import 'gameplay_screen.dart';

/// Intentional 2.5D Home Screen dashboard with campaign progression, settings & skin integration.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ProgressService.instance.loadProgress();
    AudioService.instance.playMenuMusic();
  }

  void _startGame(BuildContext context, PlayerProgressModel progress) async {
    AudioService.instance.playButtonTap();
    HapticService.instance.buttonPress();

    final navigator = Navigator.of(context);
    final targetLevelId = progress.highestUnlockedLevel;
    final levelModel = await LevelLoader.loadLevelById(targetLevelId);

    if (levelModel != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => GameplayScreen(initialLevel: levelModel),
        ),
      );
    } else {
      final fallbackLevel = LevelLoader.getFallbackWorldLevels(1).first;
      navigator.push(
        MaterialPageRoute(
          builder: (context) => GameplayScreen(initialLevel: fallbackLevel),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeService.instance.equippedTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: ValueListenableBuilder<PlayerProgressModel>(
              valueListenable: ProgressService.instance.progressNotifier,
              builder: (context, progress, child) {
                return Column(
                  children: [
                    // Top Right Quick Action Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.palette_rounded),
                          color: theme.textPrimary,
                          tooltip: 'Skin Gallery',
                          onPressed: () {
                            AudioService.instance.playButtonTap();
                            HapticService.instance.buttonPress();
                            Navigator.pushNamed(context, '/skins');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_rounded),
                          color: theme.textPrimary,
                          tooltip: 'Settings',
                          onPressed: () {
                            AudioService.instance.playButtonTap();
                            HapticService.instance.buttonPress();
                            Navigator.pushNamed(context, '/settings');
                          },
                        ),
                      ],
                    ),

                    const Spacer(flex: 2),

                    // Authentic 2.5D Logo Block Emblem Motif
                    Container(
                      width: 96,
                      height: 96,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.surfaceColor,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            offset: Offset(0, 6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
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

                    const SizedBox(height: 20),

                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'BLOCK CHANGE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                          shadows: const [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Unlocked Level Progression Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sunshine.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: AppColors.sunshine.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_circle_fill_rounded,
                            color: AppColors.sunshine,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Level ${progress.highestUnlockedLevel} Unlocked',
                            style: const TextStyle(
                              color: AppColors.sunshine,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Primary Play Action Button
                    GameButton(
                      label: 'START GAME',
                      icon: Icons.play_arrow_rounded,
                      color: AppColors.mint,
                      darkColor: AppColors.mintDark,
                      height: 56,
                      fontSize: 19,
                      onPressed: () => _startGame(context, progress),
                    ),

                    const SizedBox(height: 14),

                    // Secondary Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: GameButton(
                            label: 'CAMPAIGN MAP',
                            icon: Icons.map_rounded,
                            color: AppColors.sky,
                            darkColor: AppColors.skyDark,
                            height: 48,
                            fontSize: 14,
                            onPressed: () {
                              AudioService.instance.playButtonTap();
                              HapticService.instance.buttonPress();
                              Navigator.pushNamed(context, '/map');
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GameButton(
                            label: 'SKINS',
                            icon: Icons.palette_rounded,
                            color: theme.primaryAccent,
                            darkColor: theme.cardColor,
                            height: 48,
                            fontSize: 14,
                            onPressed: () {
                              AudioService.instance.playButtonTap();
                              HapticService.instance.buttonPress();
                              Navigator.pushNamed(context, '/skins');
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GameButton(
                            label: 'SETTINGS',
                            icon: Icons.settings_rounded,
                            color: theme.surfaceColor,
                            darkColor: theme.boardFrameColor,
                            height: 48,
                            fontSize: 14,
                            onPressed: () {
                              AudioService.instance.playButtonTap();
                              HapticService.instance.buttonPress();
                              Navigator.pushNamed(context, '/settings');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
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
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: darkColor,
            offset: const Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
    );
  }
}
