import 'package:flutter_test/flutter_test.dart';

import 'package:yoloapp/main.dart';

void main() {
  testWidgets('Check hello world smoke test!', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Hello world!'), findsOneWidget);
    expect(find.text('Potatoes!'), findsNothing);
  });
}
