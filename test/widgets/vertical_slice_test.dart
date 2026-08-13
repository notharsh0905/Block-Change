import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:block_change/app.dart';
import 'package:block_change/game/game_engine.dart';
import 'package:block_change/models/level_model.dart';
import 'package:block_change/models/tile_model.dart';
import 'package:block_change/screens/gameplay_screen.dart';
import 'package:block_change/widgets/game_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testLevel1 = const LevelModel(
    id: 1,
    worldId: 1,
    name: 'Test Level 1',
    gridSize: 3,
    colorCount: 3,
    targetColor: 0,
    initialBoard: [
      [0, 0, 0],
      [0, 1, 0],
      [0, 0, 0],
    ],
    specialTiles: [],
    timeLimitSeconds: 60.0,
    chaosConfig: ChaosConfig(enabled: false),
    starRules: StarRules(
      threeStarMaxMoves: 5,
      threeStarMinRemainingSeconds: 40.0,
      twoStarMaxMoves: 10,
      twoStarMinRemainingSeconds: 20.0,
    ),
    seed: 42,
    difficulty: Difficulty.easy,
  );

  group('Phase 3A Vertical Slice Widget Tests', () {
    testWidgets('1. Home screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(const BlockChangeApp());
      await tester.pumpAndSettle();

      expect(find.text('BLOCK CHANGE'), findsOneWidget);
      expect(find.text('START GAME'), findsOneWidget);
      expect(find.text('MAP'), findsOneWidget);
      expect(find.text('SETTINGS'), findsOneWidget);
    });

    testWidgets('2. Start Game opens gameplay screen', (WidgetTester tester) async {
      await tester.pumpWidget(const BlockChangeApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('START GAME'));
      await tester.pumpAndSettle();

      expect(find.text('LEVEL 1'), findsOneWidget);
      expect(find.text('TARGET: '), findsOneWidget);
    });

    testWidgets('3. Gameplay board renders', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GameplayScreen(initialLevel: testLevel1),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('LEVEL 1'), findsOneWidget);
      expect(find.byType(GameTileWidget), findsNWidgets(9));
    });

    testWidgets('4. Correct number of tiles renders for 3x3 grid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GameplayScreen(initialLevel: testLevel1),
        ),
      );
      await tester.pumpAndSettle();

      // 3x3 grid = 9 tiles
      expect(find.byType(GameTileWidget), findsNWidgets(9));
    });

    testWidgets('5. Tile tap reaches game engine', (WidgetTester tester) async {
      final engine = GameEngine(testLevel1);
      engine.start();

      expect(engine.value.board[1][1].colorIndex, 1);

      // Tap center tile (1,1)
      engine.tapTile(1, 1); // 1 -> 2
      expect(engine.value.board[1][1].colorIndex, 2);

      engine.tapTile(1, 1); // 2 -> 0 (matches target 0!)
      expect(engine.value.board[1][1].colorIndex, 0);
      expect(engine.value.status, GameStatus.won);
    });

    testWidgets('6. Pause overlay appears on pause button tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GameplayScreen(initialLevel: testLevel1),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Pause button
      await tester.tap(find.byIcon(Icons.pause_circle_filled_rounded));
      await tester.pumpAndSettle();

      expect(find.text('GAME PAUSED'), findsOneWidget);
      expect(find.text('RESUME'), findsOneWidget);
      expect(find.text('RESTART'), findsOneWidget);
      expect(find.text('EXIT TO HOME'), findsOneWidget);
    });

    testWidgets('7. Win overlay appears when level is completed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GameplayScreen(initialLevel: testLevel1),
        ),
      );
      await tester.pumpAndSettle();

      // Tap center tile (1,1) twice to cycle 1 -> 2 -> 0 (matches target 0)
      final centerTileFinder = find.byKey(const ValueKey('tile_1_1'));
      await tester.tap(centerTileFinder);
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(centerTileFinder);
      await tester.pumpAndSettle();

      expect(find.text('🎉 LEVEL COMPLETE!'), findsOneWidget);
      expect(find.text('NEXT LEVEL'), findsOneWidget);
      expect(find.text('REPLAY'), findsOneWidget);
    });

    testWidgets('8. Next Level loads another level from win overlay',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GameplayScreen(initialLevel: testLevel1),
        ),
      );
      await tester.pumpAndSettle();

      // Win level 1
      final centerTileFinder = find.byKey(const ValueKey('tile_1_1'));
      await tester.tap(centerTileFinder);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(centerTileFinder);
      await tester.pumpAndSettle();

      // Tap NEXT LEVEL
      await tester.tap(find.text('NEXT LEVEL'));
      await tester.pumpAndSettle();

      expect(find.text('LEVEL 2'), findsOneWidget);
    });

    testWidgets('9. Replay resets current level from win overlay',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GameplayScreen(initialLevel: testLevel1),
        ),
      );
      await tester.pumpAndSettle();

      // Win level 1
      final centerTileFinder = find.byKey(const ValueKey('tile_1_1'));
      await tester.tap(centerTileFinder);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(centerTileFinder);
      await tester.pumpAndSettle();

      // Tap REPLAY
      await tester.tap(find.text('REPLAY'));
      await tester.pumpAndSettle();

      expect(find.text('LEVEL 1'), findsOneWidget);
      expect(find.text('🎉 LEVEL COMPLETE!'), findsNothing);
    });
  });
}
