import 'level_model.dart';
import 'tile_model.dart';

/// Active game flow lifecycle states.
enum GameStatus { ready, playing, paused, won, timeUp, offlineBlocked }

/// Recent event triggers for particle and audio triggers.
enum EngineEvent { none, tileTapped, bombExploded, freezeTriggered, lockExpired, chaosTriggered, win, timeUp }

/// Immutable snapshot of live gameplay state.
class GameStateModel {
  final LevelModel level;
  final List<List<TileModel>> board;
  final GameStatus status;
  final double timeRemainingSeconds;
  final double freezeRemainingSeconds;
  final double currentChaosInterval;
  final double chaosTimerSeconds;
  final int movesCount;
  final int score;
  final EngineEvent lastEvent;

  const GameStateModel({
    required this.level,
    required this.board,
    this.status = GameStatus.ready,
    required this.timeRemainingSeconds,
    this.freezeRemainingSeconds = 0.0,
    required this.currentChaosInterval,
    this.chaosTimerSeconds = 0.0,
    this.movesCount = 0,
    this.score = 0,
    this.lastEvent = EngineEvent.none,
  });

  bool get isFrozen => freezeRemainingSeconds > 0.0;
  int get targetColor => level.targetColor;

  GameStateModel copyWith({
    LevelModel? level,
    List<List<TileModel>>? board,
    GameStatus? status,
    double? timeRemainingSeconds,
    double? freezeRemainingSeconds,
    double? currentChaosInterval,
    double? chaosTimerSeconds,
    int? movesCount,
    int? score,
    EngineEvent? lastEvent,
  }) {
    return GameStateModel(
      level: level ?? this.level,
      board: board ?? this.board,
      status: status ?? this.status,
      timeRemainingSeconds: timeRemainingSeconds ?? this.timeRemainingSeconds,
      freezeRemainingSeconds:
          freezeRemainingSeconds ?? this.freezeRemainingSeconds,
      currentChaosInterval: currentChaosInterval ?? this.currentChaosInterval,
      chaosTimerSeconds: chaosTimerSeconds ?? this.chaosTimerSeconds,
      movesCount: movesCount ?? this.movesCount,
      score: score ?? this.score,
      lastEvent: lastEvent ?? EngineEvent.none,
    );
  }
}
