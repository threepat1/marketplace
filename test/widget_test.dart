// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/main.dart';
import 'package:marketplace/presentation/home/main_screen.dart'; // adjust import if main.dart is in a different folder

void main() {
  testWidgets('App builds main screen', (WidgetTester tester) async {
    // Pump the app
    await tester.pumpWidget(const MyApp());

    // Verify MainScreen is in the widget tree
    expect(find.byType(MainScreen), findsOneWidget);
  });
}
