import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace/data/models/product_model.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tProductModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Sample product description',
    currentBid: 100.5,
    endTime: DateTime.parse('2024-05-17T12:00:00.000Z'),
    imageUrl: 'http://example.com/image.png',
    categoryPath: 'Category/Sub',
    createdBy: 'user001',
    province: 'Bangkok',
    postcode: '10110',
    bidIncrement: 5.0,
  );

  test('should return a valid model from JSON', () {
    final Map<String, dynamic> jsonMap =
        jsonDecode(fixture('product.json')) as Map<String, dynamic>;

    final result = ProductModel.fromJson(jsonMap);

    expect(result, tProductModel);
  });

  test('should return a JSON map containing proper data', () {
    final result = tProductModel.toJson();

    final expectedMap = {
      'id': '1',
      'name': 'Test Product',
      'description': 'Sample product description',
      'currentBid': 100.5,
      'endTime': '2024-05-17T12:00:00.000Z',
      'imageUrl': 'http://example.com/image.png',
      'categoryPath': 'Category/Sub',
      'createdBy': 'user001',
      'province': 'Bangkok',
      'postcode': '10110',
      'bidIncrement': 5.0,
    };

    expect(result, expectedMap);
  });

  test('should gracefully handle invalid values', () {
    final Map<String, dynamic> jsonMap = {
      'id': '1',
      'name': 'Invalid',
      'description': 'Invalid',
      'currentBid': 'not a number',
      'endTime': 'invalid date',
      'imageUrl': 'url',
      'categoryPath': 'path',
      'createdBy': 'user',
      'province': 'province',
      'postcode': '00000',
      'bidIncrement': null,
    };

    final result = ProductModel.fromJson(jsonMap);

    expect(result.currentBid, 0.0);
    expect(result.bidIncrement, 0.0);
    expect(result.endTime, DateTime.fromMillisecondsSinceEpoch(0));
  });
}
