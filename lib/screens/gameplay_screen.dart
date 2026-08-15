import 'dart:async';

import 'package:flutter/material.dart';

import '../data/level_loader.dart';
import '../game/game_engine.dart';
import '../game/star_calculator.dart';
import '../models/game_state_model.dart';
import '../models/level_model.dart';
import '../services/progress_service.dart';
import '../theme/app_colors.dart';
import '../widgets/dialogs/pause_overlay.dart';
import '../widgets/dialogs/win_overlay.dart';
import '../widgets/game_board.dart';
import '../widgets/game_button.dart';

/// Main Playable Puzzle Screen — Refactored Single Source of Truth for Campaign Progression.
class GameplayScreen extends StatefulWidget {
  final LevelModel? initialLevel;
  final List<LevelModel>? availableLevels;

  const GameplayScreen({super.key, this.initialLevel, this.availableLevels});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  LevelModel? _currentLevel;
  List<LevelModel>? _testAvailableLevels;
  int _testLevelIndex = 0;

  GameEngine? _engine;
  Timer? _tickerTimer;
  bool _isOverlayShowing = false;

  @override
  void initState() {
    super.initState();
    _initLevelsAndStart();
  }

  Future<void> _initLevelsAndStart() async {
    if (widget.availableLevels != null && widget.availableLevels!.isNotEmpty) {
      // Direct widget test injection
      _testAvailableLevels = widget.availableLevels;
      _testLevelIndex = 0;
      _currentLevel = _testAvailableLevels!.first;
    } else if (widget.initialLevel != null) {
      _currentLevel = widget.initialLevel;
    } else {
      // Single Source of Truth: load current highest unlocked level
      final progress = await ProgressService.instance.loadProgress();
      _currentLevel = await LevelLoader.loadLevelById(
        progress.highestUnlockedLevel,
      );
      _currentLevel ??= LevelLoader.getFallbackWorldLevels(1).first;
    }

    _loadCurrentLevel();
  }

  void _loadCurrentLevel() {
    if (_currentLevel == null) return;
    _tickerTimer?.cancel();
    _isOverlayShowing = false;

    _engine = GameEngine(_currentLevel!);
    _engine!.addListener(_onEngineStateChanged);
    _engine!.start();

    // Start 50ms engine tick loop (20 ticks/sec)
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_engine != null && _engine!.value.status == GameStatus.playing) {
        _engine!.update(0.05);
      }
    });

    setState(() {});
  }

  void _onEngineStateChanged() {
    if (_engine == null || _isOverlayShowing) return;

    final status = _engine!.value.status;
    if (status == GameStatus.won) {
      _isOverlayShowing = true;
      _showWinOverlay();
    } else if (status == GameStatus.paused) {
      _isOverlayShowing = true;
      _showPauseOverlay();
    }
  }

  void _showWinOverlay() {
    final state = _engine!.value;
    final stars = StarCalculator.calculateStars(
      starRules: state.level.starRules,
      movesCount: state.movesCount,
      timeRemainingSeconds: state.timeRemainingSeconds,
    );

    // Save player progress & high scores locally via Single Source of Truth ProgressService
    ProgressService.instance.recordLevelCompletion(
      levelId: state.level.id,
      stars: stars,
      score: state.score,
      moves: state.movesCount,
      timeRemainingSeconds: state.timeRemainingSeconds,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WinOverlay(
          levelNumber: state.level.id,
          score: state.score,
          moves: state.movesCount,
          stars: stars,
          onNextLevel: () {
            Navigator.of(context).pop();
            _nextLevel();
          },
          onReplay: () {
            Navigator.of(context).pop();
            _loadCurrentLevel();
          },
        );
      },
    );
  }

  void _showPauseOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PauseOverlay(
          onResume: () {
            Navigator.of(context).pop();
            _isOverlayShowing = false;
            _engine?.resume();
          },
          onRestart: () {
            Navigator.of(context).pop();
            _loadCurrentLevel();
          },
          onExit: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _nextLevel() async {
    // 1. Handle widget test injection override if explicitly provided
    if (_testAvailableLevels != null && _testAvailableLevels!.length > 1) {
      if (_testLevelIndex < _testAvailableLevels!.length - 1) {
        _testLevelIndex++;
      } else {
        _testLevelIndex = 0;
      }
      _currentLevel = _testAvailableLevels![_testLevelIndex];
      _loadCurrentLevel();
      return;
    }

    if (_currentLevel == null) return;
    final currentId = _currentLevel!.id;

    // 2. Handle Level 100 Endgame (PRD Part A2: Never wrap Level 100 -> Level 1!)
    if (currentId >= 100) {
      _showCampaignClearedDialog();
      return;
    }

    // 3. Single Source of Truth Campaign Progression (Next Level = currentId + 1)
    final nextId = ProgressService.instance.getNextLevelId(currentId);

    LevelModel? nextLevel = await LevelLoader.loadLevelById(nextId);

    // 4. Safe fallback for unit test environments
    nextLevel ??= LevelLoader.getFallbackWorldLevels((nextId - 1) ~/ 10 + 1)
        .firstWhere(
          (l) => l.id == nextId,
          orElse: () => LevelLoader.getFallbackWorldLevels(1).first,
        );

    if (nextLevel.id == 1 && currentId >= 1) {
      // Diagnostic Guard: Prevent invalid fallback wraparound to Level 1
      debugPrint(
        'CRITICAL PROGRESSION GUARD: Prevented wraparound from Level $currentId to Level 1',
      );
      _showCampaignClearedDialog();
      return;
    }

    _currentLevel = nextLevel;
    _loadCurrentLevel();
  }

  void _showCampaignClearedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.sunshine,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'CAMPAIGN CLEARED!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Congratulations! You have completed all 100 levels of Block Change!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                GameButton(
                  label: 'CAMPAIGN MAP',
                  icon: Icons.map_rounded,
                  color: AppColors.mint,
                  darkColor: AppColors.mintDark,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _engine?.removeListener(_onEngineStateChanged);
    _engine?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_engine == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ValueListenableBuilder<GameStateModel>(
      valueListenable: _engine!,
      builder: (context, state, child) {
        final targetColor = AppColors
            .gamePalette[state.targetColor % AppColors.gamePalette.length];

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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  children: [
                    // Top HUD Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Level Details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LEVEL ${state.level.id}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              state.level.name,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        // Target Color Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                              color: AppColors.surfaceElevated,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'TARGET: ',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: targetColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.gamePaletteDark[state
                                                  .targetColor %
                                              AppColors.gamePaletteDark.length],
                                      offset: const Offset(0, 2),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Pause Button
                        IconButton(
                          onPressed: () => _engine?.pause(),
                          icon: const Icon(
                            Icons.pause_circle_filled_rounded,
                            color: AppColors.textPrimary,
                            size: 36,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Metrics Bar (Timer, Moves, Freeze)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.timer_rounded,
                                color: AppColors.sky,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${state.timeRemainingSeconds.ceil()}s',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.touch_app_rounded,
                                color: AppColors.mint,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${state.movesCount}',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (state.isFrozen)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.sky,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.ac_unit_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${state.freezeRemainingSeconds.ceil()}s',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: GameBoardWidget(
                          board: state.board,
                          onTileTap: (r, c) => _engine?.tapTile(r, c),
                        ),
                      ),
                    ),

                    // Contextual Tutorial Step Banner
                    if (state.level.tutorialStep != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          state.level.tutorialStep!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.sunshine,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
