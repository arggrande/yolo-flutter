import 'package:flutter_test/flutter_test.dart';

import 'package:yoloapp/main.dart';

void main() {
  testWidgets('Check hello world smoke test!', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('Hello world!'), findsOneWidget);
    expect(find.text('Potatoes!'), findsNothing);
  });
}
