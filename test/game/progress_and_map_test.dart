import 'package:block_change/models/player_progress_model.dart';
import 'package:block_change/services/progress_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryProgressStorage storage;
  late ProgressService progressService;

  setUp(() {
    storage = InMemoryProgressStorage();
    progressService = ProgressService(storage: storage);
    ProgressService.resetInstanceForTesting(storage);
  });

  group('Phase 4 — Player Progress & Campaign Map Persistence Tests', () {
    test('1. Fresh install unlocks Level 1', () {
      final initial = progressService.currentProgress;
      expect(initial.highestUnlockedLevel, equals(1));
      expect(initial.isLevelUnlocked(1), isTrue);
    });

    test('2. Levels 2–100 are initially locked on fresh install', () {
      final initial = progressService.currentProgress;
      for (int i = 2; i <= 100; i++) {
        expect(
          initial.isLevelUnlocked(i),
          isFalse,
          reason: 'Level $i should be initially locked',
        );
      }
    });

    test('3. Completing Level 1 unlocks Level 2', () async {
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 1500,
        moves: 4,
        timeRemainingSeconds: 25.0,
      );

      final updated = progressService.currentProgress;
      expect(updated.highestUnlockedLevel, equals(2));
      expect(updated.isLevelUnlocked(2), isTrue);
      expect(updated.completedLevels.contains(1), isTrue);
    });

    test('4. Completing Level 10 unlocks World 2 (Level 11)', () async {
      for (int i = 1; i <= 10; i++) {
        await progressService.recordLevelCompletion(
          levelId: i,
          stars: 2,
          score: 1000 + i * 100,
          moves: 5,
          timeRemainingSeconds: 20.0,
        );
      }

      final progress = progressService.currentProgress;
      expect(progress.highestUnlockedLevel, equals(11));
      expect(progress.isWorldUnlocked(2), isTrue);
    });

    test('5. Completed level displays stars correctly', () async {
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 2000,
        moves: 3,
        timeRemainingSeconds: 28.0,
      );

      expect(progressService.currentProgress.getStars(1), equals(3));
    });

    test('6. Replay does not remove completion status', () async {
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 2000,
        moves: 3,
        timeRemainingSeconds: 28.0,
      );

      // Replay with lower performance
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 1,
        score: 500,
        moves: 10,
        timeRemainingSeconds: 5.0,
      );

      final progress = progressService.currentProgress;
      expect(progress.completedLevels.contains(1), isTrue);
    });

    test('7. Improved stars replace previous lower stars', () async {
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 1,
        score: 800,
        moves: 8,
        timeRemainingSeconds: 10.0,
      );
      expect(progressService.currentProgress.getStars(1), equals(1));

      // Replay and earn 3 stars
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 2500,
        moves: 3,
        timeRemainingSeconds: 29.0,
      );
      expect(progressService.currentProgress.getStars(1), equals(3));
    });

    test('8. Lower stars NEVER replace higher stars', () async {
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 2500,
        moves: 3,
        timeRemainingSeconds: 29.0,
      );

      // Replay and earn 1 star
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 1,
        score: 500,
        moves: 12,
        timeRemainingSeconds: 2.0,
      );

      expect(progressService.currentProgress.getStars(1), equals(3));
    });

    test('9. Best score is preserved and non-downgrading', () async {
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 3000,
        moves: 4,
        timeRemainingSeconds: 20.0,
      );

      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 2,
        score: 1200,
        moves: 6,
        timeRemainingSeconds: 15.0,
      );

      expect(progressService.currentProgress.getBestScore(1), equals(3000));
    });

    test('10. Best moves count is preserved and non-downgrading', () async {
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 2000,
        moves: 3,
        timeRemainingSeconds: 20.0,
      );

      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 2,
        score: 1500,
        moves: 7,
        timeRemainingSeconds: 10.0,
      );

      expect(progressService.currentProgress.getBestMoves(1), equals(3));
    });

    test('11. Best time remaining is preserved and non-downgrading', () async {
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 2000,
        moves: 3,
        timeRemainingSeconds: 28.5,
      );

      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 2,
        score: 1500,
        moves: 5,
        timeRemainingSeconds: 12.0,
      );

      expect(progressService.currentProgress.getBestTime(1), equals(28.5));
    });

    test('12. Progress persists after app reload/restart simulation', () async {
      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 2000,
        moves: 3,
        timeRemainingSeconds: 25.0,
      );
      await progressService.recordLevelCompletion(
        levelId: 2,
        stars: 2,
        score: 1800,
        moves: 5,
        timeRemainingSeconds: 20.0,
      );

      // Simulate app restart with same underlying storage
      final newService = ProgressService(storage: storage);
      final reloaded = await newService.loadProgress();

      expect(reloaded.highestUnlockedLevel, equals(3));
      expect(reloaded.completedLevels, containsAll([1, 2]));
      expect(reloaded.getStars(1), equals(3));
      expect(reloaded.getStars(2), equals(2));
    });

    test('13. Locked level cannot open gameplay', () {
      final progress = progressService.currentProgress;
      expect(progress.isLevelUnlocked(5), isFalse);
      expect(progress.isLevelUnlocked(50), isFalse);
    });

    test('14. Current level is highlighted correctly', () async {
      expect(progressService.currentProgress.highestUnlockedLevel, equals(1));

      await progressService.recordLevelCompletion(
        levelId: 1,
        stars: 3,
        score: 1000,
        moves: 4,
        timeRemainingSeconds: 20.0,
      );

      expect(progressService.currentProgress.highestUnlockedLevel, equals(2));
    });

    test('15. World completion statistics are calculated correctly', () async {
      for (int i = 1; i <= 5; i++) {
        await progressService.recordLevelCompletion(
          levelId: i,
          stars: 3,
          score: 1000,
          moves: 4,
          timeRemainingSeconds: 20.0,
        );
      }

      final progress = progressService.currentProgress;
      expect(progress.getWorldCompletedCount(1), equals(5));
      expect(progress.getWorldEarnedStars(1), equals(15));
      expect(progress.getWorldCompletedCount(2), equals(0));
    });

    test(
      '16. Progress JSON serialization and deserialization works seamlessly',
      () {
        const model = PlayerProgressModel(
          highestUnlockedLevel: 12,
          completedLevels: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},
          starsByLevel: {1: 3, 2: 3, 3: 2},
          bestScoreByLevel: {1: 3000, 2: 2500},
          bestMovesByLevel: {1: 3, 2: 4},
          bestTimeByLevel: {1: 28.5, 2: 22.0},
          currentLevelId: 12,
          selectedWorldId: 2,
        );

        final encoded = model.encodeJson();
        final decoded = PlayerProgressModel.decodeJson(encoded);

        expect(decoded.highestUnlockedLevel, equals(12));
        expect(
          decoded.completedLevels,
          equals({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}),
        );
        expect(decoded.getStars(1), equals(3));
        expect(decoded.getStars(3), equals(2));
        expect(decoded.getBestScore(1), equals(3000));
        expect(decoded.getBestMoves(2), equals(4));
        expect(decoded.getBestTime(1), equals(28.5));
        expect(decoded.selectedWorldId, equals(2));
      },
    );
  });
}
