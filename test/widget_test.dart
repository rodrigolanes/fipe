import 'package:fipe/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FipeApp());

    // Verify that splash screen is displayed
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
