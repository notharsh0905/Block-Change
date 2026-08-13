import 'package:flutter_test/flutter_test.dart';
import 'package:block_change/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BlockChangeApp());
    await tester.pumpAndSettle();

    expect(find.text('BLOCK CHANGE'), findsOneWidget);
    expect(find.text('START GAME'), findsOneWidget);
  });
}
