import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/products/widgets/bidding_product_view.dart';
import 'package:marketplace/presentation/products/bloc/product_bloc.dart';
import 'package:marketplace/domain/entities/product.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Bidding'),
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return DropdownButton<String>(
                value: state.viewType,
                icon: const Icon(Icons.view_list, color: Colors.white),
                dropdownColor: Colors.blue,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                      value: "List",
                      child: Text("List View",
                          style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(
                      value: "Grid",
                      child: Text("Grid View",
                          style: TextStyle(color: Colors.white))),
                ],
                onChanged: (value) {
                  // THIS IS THE CORRECTED LINE
                  context.read<ProductBloc>().add(ToggleViewEvent());
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.status == ProductStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ProductStatus.success) {
            return _buildProductView(state.viewType, state.products);
          } else if (state.status == ProductStatus.failure) {
            return const Center(child: Text('Failed to load products'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProductView(String viewType, List<Product> products) {
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
