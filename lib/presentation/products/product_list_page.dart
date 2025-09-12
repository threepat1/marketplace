import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/products/widgets/bidding_product_view.dart';
import 'package:marketplace/presentation/products/bloc/product_bloc.dart';
import 'package:marketplace/domain/entities/product.dart';

class _Category {
  final IconData icon;
  final String name;

  const _Category(this.icon, this.name);
}

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});
  final List<String> _categories = const [
    'All',
    'Electronics',
    'Fashion',
    'Books',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Bidding'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: Chip(label: Text(_categories[index])),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return DropdownButton<String>(
                  value: state.viewType,
                  icon: const Icon(Icons.view_list),
                  items: const [
                    DropdownMenuItem(value: 'List', child: Text('List View')),
                    DropdownMenuItem(value: 'Grid', child: Text('Grid View')),
                  ],
                  onChanged: (value) {
                    context
                        .read<ProductBloc>()
                        .add(SetViewTypeEvent(viewType: value!));
                  },
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
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
          )
        ]));
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
          childAspectRatio: 9 / 16,
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
