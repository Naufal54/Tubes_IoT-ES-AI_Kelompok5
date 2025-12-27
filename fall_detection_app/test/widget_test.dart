// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:eldercare/app/app.dart';
import 'package:eldercare/features/home/page/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launches and displays HomePage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for animations and navigation to settle
    await tester.pumpAndSettle();

    // Verify that HomePage is displayed
    expect(find.byType(HomePage), findsOneWidget);
  });
}
