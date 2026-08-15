import 'package:block_change/data/level_loader.dart';
import 'package:block_change/game/level_validator.dart';
import 'package:block_change/services/progress_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late InMemoryProgressStorage storage;
  late ProgressService progressService;

  setUp(() {
    storage = InMemoryProgressStorage();
    progressService = ProgressService(storage: storage);
    ProgressService.resetInstanceForTesting(storage);
  });

  group(
    'Phase 4.1 — Critical Progression Regression & Replay Isolation Tests',
    () {
      test('1. Sequential progression from Level 11 through Level 16 (No Level 1 wraparound)', () async {
        // Fast-forward progress to Level 11
        for (int i = 1; i <= 10; i++) {
          await progressService.recordLevelCompletion(
            levelId: i,
            stars: 3,
            score: 1000 + i * 100,
            moves: 4,
            timeRemainingSeconds: 30.0,
          );
        }
        expect(progressService.highestUnlockedLevel, equals(11));

        // Complete Level 11 -> Level 12
        var updated = await progressService.recordLevelCompletion(
          levelId: 11,
          stars: 3,
          score: 2000,
          moves: 5,
          timeRemainingSeconds: 25.0,
        );
        expect(updated.highestUnlockedLevel, equals(12));
        expect(progressService.getNextLevelId(11), equals(12));
        expect(updated.highestUnlockedLevel, isNot(equals(1)));

        // Complete Level 12 -> Level 13
        updated = await progressService.recordLevelCompletion(
          levelId: 12,
          stars: 3,
          score: 2100,
          moves: 5,
          timeRemainingSeconds: 25.0,
        );
        expect(updated.highestUnlockedLevel, equals(13));
        expect(progressService.getNextLevelId(12), equals(13));
        expect(updated.highestUnlockedLevel, isNot(equals(1)));

        // Complete Level 13 -> Level 14
        updated = await progressService.recordLevelCompletion(
          levelId: 13,
          stars: 3,
          score: 2200,
          moves: 5,
          timeRemainingSeconds: 25.0,
        );
        expect(updated.highestUnlockedLevel, equals(14));
        expect(progressService.getNextLevelId(13), equals(14));
        expect(updated.highestUnlockedLevel, isNot(equals(1)));

        // Complete Level 14 -> Level 15
        updated = await progressService.recordLevelCompletion(
          levelId: 14,
          stars: 3,
          score: 2300,
          moves: 5,
          timeRemainingSeconds: 25.0,
        );
        expect(updated.highestUnlockedLevel, equals(15));
        expect(progressService.getNextLevelId(14), equals(15));
        expect(updated.highestUnlockedLevel, isNot(equals(1)));

        // Complete Level 15 -> Level 16
        updated = await progressService.recordLevelCompletion(
          levelId: 15,
          stars: 3,
          score: 2400,
          moves: 5,
          timeRemainingSeconds: 25.0,
        );
        expect(updated.highestUnlockedLevel, equals(16));
        expect(progressService.getNextLevelId(15), equals(16));
        expect(updated.highestUnlockedLevel, isNot(equals(1)));
      });

      test('2. Replaying Level 12 while Level 15 is unlocked preserves highestUnlockedLevel = 15', () async {
        // Fast-forward to Level 15
        for (int i = 1; i <= 14; i++) {
          await progressService.recordLevelCompletion(
            levelId: i,
            stars: 2,
            score: 1000,
            moves: 6,
            timeRemainingSeconds: 20.0,
          );
        }
        expect(progressService.highestUnlockedLevel, equals(15));

        // Replay Level 12 and improve stars/score
        final replayed = await progressService.recordLevelCompletion(
          levelId: 12,
          stars: 3,
          score: 3500,
          moves: 3,
          timeRemainingSeconds: 40.0,
        );

        // Verify Level 12 stats updated BUT highestUnlockedLevel stays 15
        expect(replayed.highestUnlockedLevel, equals(15));
        expect(replayed.getStars(12), equals(3));
        expect(replayed.getBestScore(12), equals(3500));
        expect(replayed.completedLevels, contains(14));
        expect(progressService.highestUnlockedLevel, equals(15));
      });

      test('3. Level 99 -> Level 100 -> Campaign Completion (Never wraps to Level 1)', () async {
        // Fast-forward to Level 99
        for (int i = 1; i <= 98; i++) {
          await progressService.recordLevelCompletion(
            levelId: i,
            stars: 3,
            score: 1000,
            moves: 4,
            timeRemainingSeconds: 20.0,
          );
        }
        expect(progressService.highestUnlockedLevel, equals(99));

        // Complete Level 99
        var updated = await progressService.recordLevelCompletion(
          levelId: 99,
          stars: 3,
          score: 5000,
          moves: 4,
          timeRemainingSeconds: 20.0,
        );
        expect(updated.highestUnlockedLevel, equals(100));
        expect(progressService.getNextLevelId(99), equals(100));

        // Complete Level 100
        updated = await progressService.recordLevelCompletion(
          levelId: 100,
          stars: 3,
          score: 9999,
          moves: 5,
          timeRemainingSeconds: 25.0,
        );

        expect(updated.highestUnlockedLevel, equals(100));
        expect(progressService.getNextLevelId(100), equals(100));
        expect(updated.highestUnlockedLevel, isNot(equals(1)));
      });

      test('4. World 1 levels have deliberate archetypes and titles', () async {
        final world1Levels = LevelLoader.getFallbackWorldLevels(1);
        final expectedTitles = [
          'First Tap',
          'Two Steps',
          'Almost There',
          'Chaos Arrives',
          'Beat the Clock',
          'Corner Case',
          'Color Trap',
          'Clean Run',
          'Chaos Rush',
          'First Challenge',
        ];

        expect(world1Levels.length, equals(10));
        for (int i = 0; i < 10; i++) {
          expect(world1Levels[i].name, equals(expectedTitles[i]));
        }
      });

      test(
        '5. LevelValidator proves schema validity on all 100 campaign levels',
        () async {
          for (int w = 1; w <= 10; w++) {
            final levels = LevelLoader.getFallbackWorldLevels(w);
            for (final level in levels) {
              final errors = LevelValidator.validateLevel(level);
              expect(
                errors,
                isEmpty,
                reason: 'Level ${level.id} should have zero validation errors',
              );
            }
          }
        },
      );
    },
  );
}
