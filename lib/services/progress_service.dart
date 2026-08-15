import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/player_progress_model.dart';

/// Storage Key for campaign progress payload in SharedPreferences.
const String kPlayerProgressStorageKey = 'block_change_player_progress_v1';

/// Abstract storage interface for decoupling persistence in tests vs runtime SharedPreferences.
abstract class IProgressStorage {
  Future<String?> getString(String key);
  Future<bool> setString(String key, String value);
  Future<bool> remove(String key);
}

/// SharedPreferences implementation of [IProgressStorage].
class SharedPreferencesStorage implements IProgressStorage {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<String?> getString(String key) async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(key);
    } catch (e) {
      debugPrint('SharedPreferencesStorage getString error: $e');
      return null;
    }
  }

  @override
  Future<bool> setString(String key, String value) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setString(key, value);
    } catch (e) {
      debugPrint('SharedPreferencesStorage setString error: $e');
      return false;
    }
  }

  @override
  Future<bool> remove(String key) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.remove(key);
    } catch (e) {
      debugPrint('SharedPreferencesStorage remove error: $e');
      return false;
    }
  }
}

/// In-memory implementation of [IProgressStorage] for unit tests & isolated environments.
class InMemoryProgressStorage implements IProgressStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> getString(String key) async => _storage[key];

  @override
  Future<bool> setString(String key, String value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _storage.remove(key);
    return true;
  }
}

/// Authoritative Campaign Progress Controller & Service repository managing local player state and save safety.
class ProgressService {
  static ProgressService? _instance;
  static ProgressService get instance => _instance ??= ProgressService();

  static void resetInstanceForTesting([IProgressStorage? storage]) {
    _instance = ProgressService(storage: storage);
  }

  final IProgressStorage _storage;
  final ValueNotifier<PlayerProgressModel> progressNotifier;

  ProgressService({
    IProgressStorage? storage,
    PlayerProgressModel? initialProgress,
  }) : _storage = storage ?? SharedPreferencesStorage(),
       progressNotifier = ValueNotifier<PlayerProgressModel>(
         initialProgress ?? PlayerProgressModel.initial(),
       );

  /// Current in-memory cached player progress instance.
  PlayerProgressModel get currentProgress => progressNotifier.value;

  /// Authoritative campaign progress getters.
  int get highestUnlockedLevel => progressNotifier.value.highestUnlockedLevel;
  bool isLevelUnlocked(int levelId) =>
      progressNotifier.value.isLevelUnlocked(levelId);

  /// Authoritative Next Level ID calculator (PRD Part A2):
  /// - For levels 1–99: returns levelId + 1
  /// - For Level 100: returns 100 (never wraps to 1!)
  int getNextLevelId(int currentLevelId) {
    if (currentLevelId <= 0) return 1;
    if (currentLevelId >= 100) return 100;
    return currentLevelId + 1;
  }

  /// Loads stored progress from local storage, fallback to initial state on fresh install.
  Future<PlayerProgressModel> loadProgress() async {
    final rawJson = await _storage.getString(kPlayerProgressStorageKey);
    if (rawJson == null || rawJson.isEmpty) {
      progressNotifier.value = PlayerProgressModel.initial();
      return progressNotifier.value;
    }

    try {
      progressNotifier.value = PlayerProgressModel.decodeJson(rawJson);
    } catch (e) {
      debugPrint(
        'Failed to decode stored player progress payload: $e. Falling back to initial.',
      );
      progressNotifier.value = PlayerProgressModel.initial();
    }

    return progressNotifier.value;
  }

  /// Persists [progress] payload to local storage safely.
  Future<bool> saveProgress(PlayerProgressModel progress) async {
    progressNotifier.value = progress;
    return await _storage.setString(
      kPlayerProgressStorageKey,
      progress.encodeJson(),
    );
  }

  /// Records level completion, updates high scores/stars without downgrading, and persists to disk.
  Future<PlayerProgressModel> recordLevelCompletion({
    required int levelId,
    required int stars,
    required int score,
    required int moves,
    required double timeRemainingSeconds,
  }) async {
    final updated = progressNotifier.value.recordCompletion(
      levelId: levelId,
      stars: stars,
      score: score,
      moves: moves,
      timeRemainingSeconds: timeRemainingSeconds,
    );

    await saveProgress(updated);
    return updated;
  }

  /// Developer/test reset method to restore fresh install state.
  Future<PlayerProgressModel> resetProgress() async {
    progressNotifier.value = PlayerProgressModel.initial();
    await _storage.remove(kPlayerProgressStorageKey);
    return progressNotifier.value;
  }
}
