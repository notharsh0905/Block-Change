import 'dart:math' as math;
import 'package:flutter/foundation.dart';

import '../models/game_state_model.dart';
import '../models/level_model.dart';
import '../models/tile_model.dart';
import 'chaos_manager.dart';
import 'game_rules.dart';
import 'level_validator.dart';
import 'tile_manager.dart';

/// Centralized deterministic state machine and game logic controller.
///
/// Implements pure, testable game loop logic decoupled from UI widgets.
class GameEngine extends ValueNotifier<GameStateModel> {
  math.Random _rng;

  GameEngine(LevelModel level, {int? seed})
      : _rng = math.Random(seed ?? level.seed),
        super(_createInitialState(level, seed ?? level.seed));

  static GameStateModel _createInitialState(LevelModel level, int seed) {
    final board = LevelValidator.buildBoardFromLevel(level);
    return GameStateModel(
      level: level,
      board: board,
      status: GameStatus.ready,
      timeRemainingSeconds: level.timeLimitSeconds,
      freezeRemainingSeconds: 0.0,
      currentChaosInterval: level.chaosConfig.initialInterval,
      chaosTimerSeconds: 0.0,
      movesCount: 0,
      score: 0,
      lastEvent: EngineEvent.none,
    );
  }

  /// Re-seeds the random number generator deterministically.
  void reseed(int seed) {
    _rng = math.Random(seed);
  }

  /// Loads an authored level definition into the engine.
  void loadLevel(LevelModel level, {int? seed}) {
    final actualSeed = seed ?? level.seed;
    _rng = math.Random(actualSeed);
    value = _createInitialState(level, actualSeed);
  }

  /// Starts or unpauses active gameplay.
  void start() {
    if (value.status == GameStatus.ready || value.status == GameStatus.paused) {
      value = value.copyWith(status: GameStatus.playing);
    }
  }

  /// Pauses active gameplay, halting timer and chaos.
  void pause() {
    if (value.status == GameStatus.playing) {
      value = value.copyWith(status: GameStatus.paused);
    }
  }

  /// Resumes paused gameplay.
  void resume() {
    if (value.status == GameStatus.paused) {
      value = value.copyWith(status: GameStatus.playing);
    }
  }

  /// Restores level to initial state.
  void restart() {
    final seed = value.level.seed;
    _rng = math.Random(seed);
    final initialState = _createInitialState(value.level, seed);
    value = initialState.copyWith(status: GameStatus.playing);
  }

  /// Handles player tap interaction on tile at ([row], [col]).
  void tapTile(int row, int col) {
    if (value.status != GameStatus.playing) return;

    final tapResult = TileManager.tapTile(
      board: value.board,
      row: row,
      col: col,
      colorCount: value.level.colorCount,
    );

    if (!tapResult.isTileChanged && !tapResult.isBombExploded && !tapResult.isFreezeTriggered) {
      return;
    }

    final newMoves = value.movesCount + 1;
    final newScore = value.score + 1;
    double newFreeze = value.freezeRemainingSeconds;
    EngineEvent event = EngineEvent.tileTapped;

    if (tapResult.isFreezeTriggered) {
      newFreeze = tapResult.freezeDurationSeconds;
      event = EngineEvent.freezeTriggered;
    } else if (tapResult.isBombExploded) {
      event = EngineEvent.bombExploded;
    }

    // Check win condition immediately after player action
    final isWon = GameRules.checkWin(tapResult.newBoard, value.targetColor);

    value = value.copyWith(
      board: tapResult.newBoard,
      movesCount: newMoves,
      score: newScore,
      freezeRemainingSeconds: newFreeze,
      status: isWon ? GameStatus.won : GameStatus.playing,
      lastEvent: isWon ? EngineEvent.win : event,
    );
  }

  /// Main timing tick step called every frame/interval update.
  void update(double dt) {
    if (value.status != GameStatus.playing) return;

    var currentBoard = value.board;
    var freezeRemaining = value.freezeRemainingSeconds;
    var timeRemaining = value.timeRemainingSeconds;
    var chaosTimer = value.chaosTimerSeconds;
    var event = EngineEvent.none;

    // 1. Update freeze timer
    if (freezeRemaining > 0.0) {
      freezeRemaining = math.max(0.0, freezeRemaining - dt);
    }

    // 2. Update locked tiles duration
    bool isAnyLockUpdated = false;
    final newBoard = currentBoard.map((row) => row.map((tile) {
      if (tile.type == TileType.lock && tile.lockRemainingSeconds > 0.0) {
        final remaining = math.max(0.0, tile.lockRemainingSeconds - dt);
        if (remaining != tile.lockRemainingSeconds) {
          isAnyLockUpdated = true;
          if (remaining == 0.0) {
            event = EngineEvent.lockExpired;
            return tile.copyWith(
              type: TileType.normal,
              lockRemainingSeconds: 0.0,
            );
          }
          return tile.copyWith(lockRemainingSeconds: remaining);
        }
      }
      return tile;
    }).toList()).toList();

    if (isAnyLockUpdated) {
      currentBoard = newBoard;
    }

    // 3. Decrement level countdown timer (only if not frozen or win)
    timeRemaining = math.max(0.0, timeRemaining - dt);

    if (timeRemaining <= 0.0) {
      value = value.copyWith(
        board: currentBoard,
        timeRemainingSeconds: 0.0,
        freezeRemainingSeconds: freezeRemaining,
        status: GameStatus.timeUp,
        lastEvent: EngineEvent.timeUp,
      );
      return;
    }

    // 4. Update automatic chaos pressure (paused while frozen or similarity > 80%)
    if (value.level.chaosConfig.enabled && freezeRemaining <= 0.0) {
      final similarity = GameRules.calculateSimilarityRatio(
        currentBoard,
        value.targetColor,
      );

      // Chaos pauses if board similarity to target is > 80% (PRD rule)
      if (similarity <= 0.8) {
        chaosTimer += dt;
        if (chaosTimer >= value.currentChaosInterval) {
          chaosTimer = 0.0;
          final chaosResult = ChaosManager.applyChaos(
            board: currentBoard,
            colorCount: value.level.colorCount,
            rng: _rng,
          );

          if (chaosResult.isMutated) {
            currentBoard = chaosResult.newBoard;
            event = EngineEvent.chaosTriggered;
          }
        }
      }
    }

    // 5. Evaluate win condition
    final isWon = GameRules.checkWin(currentBoard, value.targetColor);

    value = value.copyWith(
      board: currentBoard,
      timeRemainingSeconds: timeRemaining,
      freezeRemainingSeconds: freezeRemaining,
      chaosTimerSeconds: chaosTimer,
      status: isWon ? GameStatus.won : GameStatus.playing,
      lastEvent: isWon ? EngineEvent.win : event,
    );
  }
}
