// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/data/models/product_model.dart';
import 'package:marketplace/main.dart';
import 'package:marketplace/presentation/home/main_screen.dart'; // adjust import if main.dart is in a different folder

void main() {
  Map<String, dynamic> readFixture() {
    final file = File('test/fixtures/product.json');
    final jsonString = file.readAsStringSync();
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  group('ProductModel.fromJson', () {
    test('parses essential fields', () {
      final jsonMap = readFixture();
      final product = ProductModel.fromJson(jsonMap);

      expect(product.name, 'john_doe');
      expect(product.currentBid, '115');
      expect(product.endTime, "2024-05-17T12:00:00.000Z");
    });
  });
}
