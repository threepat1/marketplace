import 'package:flutter/material.dart';
import 'dart:async';

import 'package:marketplace/data/model/product.dart';
import 'package:marketplace/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Bidding',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductListPage(),
    );
  }
}

// Updated Product class to include bidding details
