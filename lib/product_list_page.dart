import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marketplace/bidding_product_view.dart';
import 'package:marketplace/data/model/product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String viewType = "List"; // default view

  // Products with bidding info
  final List<Product> products = [
    Product(
      name: "Smartphone",
      description: "A powerful Android phone with 128GB storage.",
      currentBid: 699.99,
      endTime: DateTime.now().add(const Duration(days: 2, hours: 5)),
      imageUrl: "https://via.placeholder.com/150",
    ),
    Product(
      name: "Laptop",
      description: "15-inch laptop with Intel i7 and 16GB RAM.",
      currentBid: 1299.99,
      endTime: DateTime.now().add(const Duration(hours: 15, minutes: 30)),
      imageUrl: "https://via.placeholder.com/150",
    ),
    Product(
      name: "Headphones",
      description: "Noise-cancelling over-ear headphones.",
      currentBid: 199.99,
      endTime: DateTime.now().add(const Duration(minutes: 5, seconds: 10)),
      imageUrl: "https://via.placeholder.com/150",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Bidding'),
        actions: [
          DropdownButton<String>(
            value: viewType,
            icon: const Icon(Icons.view_list, color: Colors.white),
            dropdownColor: Colors.blue,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: "List", child: Text("List View")),
              DropdownMenuItem(value: "Grid", child: Text("Grid View")),
            ],
            onChanged: (value) {
              setState(() {
                viewType = value!;
              });
            },
          ),
        ],
      ),
      body: _buildProductView(),
    );
  }

  Widget _buildProductView() {
    if (viewType == "List") {
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return BiddingProductView(product: product);
        },
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return BiddingProductView(product: product, isGridView: true);
        },
      );
    }
  }
}
