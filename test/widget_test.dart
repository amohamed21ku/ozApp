import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oz/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    bool isNew = logindata.getBool('login') ?? true;

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(isNew: isNew));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
