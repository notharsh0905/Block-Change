import 'package:flutter/material.dart';

import '../data/level_loader.dart';
import '../models/player_progress_model.dart';
import '../services/progress_service.dart';
import '../theme/app_colors.dart';
import 'gameplay_screen.dart';

/// Campaign World Metadata representation for map display.
class WorldInfo {
  final int id;
  final String title;
  final String description;
  final Color themeColor;
  final Color darkColor;
  final IconData icon;

  const WorldInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.themeColor,
    required this.darkColor,
    required this.icon,
  });
}

const List<WorldInfo> kWorldCatalog = [
  WorldInfo(
    id: 1,
    title: 'First Steps',
    description: 'Normal tiles & color cycling basics',
    themeColor: AppColors.mint,
    darkColor: AppColors.mintDark,
    icon: Icons.sports_score_rounded,
  ),
  WorldInfo(
    id: 2,
    title: 'Rising Chaos',
    description: 'Faster chaos & 4th Violet color',
    themeColor: AppColors.coral,
    darkColor: AppColors.coralDark,
    icon: Icons.speed_rounded,
  ),
  WorldInfo(
    id: 3,
    title: 'Boom',
    description: '3x3 area Bomb explosions',
    themeColor: AppColors.violet,
    darkColor: Color(0xFF6B30C2),
    icon: Icons.local_fire_department_rounded,
  ),
  WorldInfo(
    id: 4,
    title: 'Freeze',
    description: 'Freeze timer & Sunshine Gold',
    themeColor: AppColors.sunshine,
    darkColor: AppColors.sunshineDark,
    icon: Icons.ac_unit_rounded,
  ),
  WorldInfo(
    id: 5,
    title: 'Locked',
    description: '5s Locked tile restrictions',
    themeColor: AppColors.sky,
    darkColor: AppColors.skyDark,
    icon: Icons.lock_clock_rounded,
  ),
  WorldInfo(
    id: 6,
    title: 'Mix It Up',
    description: 'Combined special tile chaos',
    themeColor: Color(0xFFFF5252),
    darkColor: Color(0xFFC62828),
    icon: Icons.extension_rounded,
  ),
  WorldInfo(
    id: 7,
    title: 'Pressure',
    description: '6x6–7x7 grids & Cyan Aqua color',
    themeColor: Color(0xFF00E5FF),
    darkColor: Color(0xFF00838F),
    icon: Icons.grid_view_rounded,
  ),
  WorldInfo(
    id: 8,
    title: 'Expert',
    description: 'Complex matrix & tight timers',
    themeColor: Color(0xFFFF9100),
    darkColor: Color(0xFFE65100),
    icon: Icons.workspace_premium_rounded,
  ),
  WorldInfo(
    id: 9,
    title: 'Master',
    description: '8x8 grid 64-block matrix',
    themeColor: Color(0xFFD500F9),
    darkColor: Color(0xFF4A148C),
    icon: Icons.psychology_rounded,
  ),
  WorldInfo(
    id: 10,
    title: 'Color Chaos',
    description: 'Endgame campaign challenge',
    themeColor: Color(0xFFFFD700),
    darkColor: Color(0xFFB8860B),
    icon: Icons.military_tech_rounded,
  ),
];

/// Responsive 2.5D Campaign Level Map Screen displaying 10 Worlds & 100 Level Nodes.
class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onLevelTap(
    BuildContext context,
    int levelId,
    PlayerProgressModel progress,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (!progress.isLevelUnlocked(levelId)) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'Level $levelId is locked! Complete Level ${levelId - 1} to unlock.',
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final levelModel = await LevelLoader.loadLevelById(levelId);

    if (levelModel != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => GameplayScreen(initialLevel: levelModel),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to load Level $levelId asset payload.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

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
        child: SafeArea(
          child: ValueListenableBuilder<PlayerProgressModel>(
            valueListenable: ProgressService.instance.progressNotifier,
            builder: (context, progress, child) {
              int totalEarnedStars = 0;
              for (int i = 1; i <= 100; i++) {
                totalEarnedStars += progress.getStars(i);
              }

              return Column(
                children: [
                  // Top Campaign HUD Header (Responsive Layout Guard against 11px overflow)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.surfaceElevated,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.textPrimary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'CAMPAIGN MAP',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Total Stars Compact Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.sunshine,
                                size: 16,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '$totalEarnedStars/300',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 6),

                        // Completed Levels Compact Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.emoji_events_rounded,
                                color: AppColors.mint,
                                size: 15,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${progress.completedLevels.length}/100',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable 10-World Campaign Catalog
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(14.0),
                      itemCount: kWorldCatalog.length,
                      itemBuilder: (context, index) {
                        final world = kWorldCatalog[index];
                        final isUnlocked = progress.isWorldUnlocked(world.id);
                        final completedCount = progress.getWorldCompletedCount(
                          world.id,
                        );
                        final earnedStars = progress.getWorldEarnedStars(
                          world.id,
                        );

                        return _WorldCardWidget(
                          world: world,
                          isUnlocked: isUnlocked,
                          completedCount: completedCount,
                          earnedStars: earnedStars,
                          progress: progress,
                          pulseController: _pulseController,
                          onLevelTap: (id) =>
                              _onLevelTap(context, id, progress),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// World Section Card with Header Statistics and 10 Level Nodes Grid.
class _WorldCardWidget extends StatelessWidget {
  final WorldInfo world;
  final bool isUnlocked;
  final int completedCount;
  final int earnedStars;
  final PlayerProgressModel progress;
  final AnimationController pulseController;
  final Function(int levelId) onLevelTap;

  const _WorldCardWidget({
    required this.world,
    required this.isUnlocked,
    required this.completedCount,
    required this.earnedStars,
    required this.progress,
    required this.pulseController,
    required this.onLevelTap,
  });

  @override
  Widget build(BuildContext context) {
    final startLevel = (world.id - 1) * 10 + 1;
    final percent = (completedCount / 10.0 * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 18.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: isUnlocked
              ? world.themeColor.withValues(alpha: 0.5)
              : AppColors.surfaceElevated,
          width: 2.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // World Banner Header (Overflow Guarded)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? world.themeColor.withValues(alpha: 0.15)
                  : AppColors.surfaceElevated.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isUnlocked ? world.themeColor : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: isUnlocked ? world.darkColor : Colors.black45,
                        offset: const Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    isUnlocked ? world.icon : Icons.lock_rounded,
                    color: isUnlocked ? Colors.black87 : Colors.white60,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'WORLD ${world.id}',
                            style: TextStyle(
                              color: isUnlocked
                                  ? world.themeColor
                                  : AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (completedCount == 10)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.mint,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'CLEARED',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        world.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        world.description,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // World Progress Stats Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$completedCount/10',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.sunshine,
                          size: 13,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '$earnedStars/30',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$percent%',
                      style: TextStyle(
                        color: isUnlocked
                            ? world.themeColor
                            : AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.surfaceElevated),

          // 10 Level Nodes Grid (2 rows x 5 cols)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final levelId = startLevel + index;
                return _LevelNodeWidget(
                  levelId: levelId,
                  worldColor: world.themeColor,
                  worldDarkColor: world.darkColor,
                  progress: progress,
                  pulseController: pulseController,
                  onTap: () => onLevelTap(levelId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Level Node Interactive Button Widget with visual accessibility states.
class _LevelNodeWidget extends StatelessWidget {
  final int levelId;
  final Color worldColor;
  final Color worldDarkColor;
  final PlayerProgressModel progress;
  final AnimationController pulseController;
  final VoidCallback onTap;

  const _LevelNodeWidget({
    required this.levelId,
    required this.worldColor,
    required this.worldDarkColor,
    required this.progress,
    required this.pulseController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = progress.isLevelUnlocked(levelId);
    final isCompleted = progress.completedLevels.contains(levelId);
    final isCurrent = levelId == progress.highestUnlockedLevel;
    final stars = progress.getStars(levelId);

    Color bgColor = AppColors.surfaceElevated;
    Color shadowColor = const Color(0xFF1E1E2E);
    Color textColor = AppColors.textSecondary;
    IconData? stateIcon;

    if (!isUnlocked) {
      bgColor = const Color(0xFF1E1E2A);
      shadowColor = Colors.transparent;
      textColor = Colors.white30;
      stateIcon = Icons.lock_rounded;
    } else if (isCurrent) {
      bgColor = worldColor;
      shadowColor = worldDarkColor;
      textColor = Colors.black;
      stateIcon = Icons.play_arrow_rounded;
    } else if (isCompleted) {
      bgColor = AppColors.surfaceElevated;
      shadowColor = const Color(0xFF151522);
      textColor = AppColors.textPrimary;
      stateIcon = Icons.check_circle_rounded;
    } else {
      bgColor = worldColor.withValues(alpha: 0.85);
      shadowColor = worldDarkColor;
      textColor = Colors.black;
      stateIcon = Icons.play_arrow_rounded;
    }

    Widget nodeContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$levelId',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (!isCompleted && !isCurrent) ...[
              const SizedBox(width: 2),
              Icon(
                stateIcon,
                size: 11,
                color: textColor.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),

        const SizedBox(height: 3),

        if (isUnlocked)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final isEarned = (i + 1) <= stars;
              return Icon(
                isEarned ? Icons.star_rounded : Icons.star_border_rounded,
                size: 12,
                color: isEarned
                    ? (isCurrent ? Colors.black : AppColors.sunshine)
                    : (isCurrent ? Colors.black38 : AppColors.textSecondary),
              );
            }),
          )
        else
          const Icon(Icons.lock_rounded, size: 13, color: Colors.white24),
      ],
    );

    if (isCurrent) {
      nodeContent = ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.05).animate(
          CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
        ),
        child: nodeContent,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isCurrent
                ? Colors.white
                : (isUnlocked
                      ? worldColor.withValues(alpha: 0.4)
                      : AppColors.surfaceElevated),
            width: isCurrent ? 2.5 : 1.5,
          ),
          boxShadow: [
            if (isUnlocked && shadowColor != Colors.transparent)
              BoxShadow(
                color: shadowColor,
                offset: const Offset(0, 3),
                blurRadius: 0,
              ),
          ],
        ),
        child: nodeContent,
      ),
    );
  }
}
