import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/products/widgets/bidding_product_view.dart';
import 'package:marketplace/presentation/products/bloc/product_bloc.dart';
import 'package:marketplace/domain/entities/product.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});
  final List<String> _categories = const [
    'All category',
    'Antiques & Collectibles',
    'Art',
    'Boats & Aviation',
    'Business & Industrial',
    'Cars & Vehicles',
    'Coins & Currency',
    'Computers & Electronics',
    'Construction & Farm',
    'Fashion',
    'Furniture',
    'Home Goods & Decor',
    'Jewelry, Watches & Gemstones',
    'Kid & Baby Essentials',
    'Lawn & Garden',
    'Real Estate',
    'Sporting Goods',
    'Toys',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Bidding'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return DropdownButton<String>(
                  isExpanded: true,
                  value: state.selectedCategory.isNotEmpty
                      ? state.selectedCategory
                      : _categories.first,
                  items: _categories
                      .map((category) => DropdownMenuItem(
                          value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<ProductBloc>()
                          .add(SetCategoryEvent(category: value));
                    }
                  },
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
                  return _buildProductView(
                      state.viewType, state.products, state.selectedCategory);
                } else if (state.status == ProductStatus.failure) {
                  return const Center(child: Text('Failed to load products'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          )
        ]));
  }

  Widget _buildProductView(
      String viewType, List<Product> products, String selectedCategory) {
    final filteredProducts = selectedCategory == "All category"
        ? products
        : products
            .where((p) => p.fullCategoryPath == selectedCategory)
            .toList();

    if (viewType == "List") {
      return ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
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
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return BiddingProductView(product: product, isGridView: true);
        },
      );
    }
  }
}
