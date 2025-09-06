part of 'product_bloc.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> products;
  final String viewType; // The property to hold the view type

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const <Product>[],
    this.viewType = 'List', // Default to 'List' view
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? viewType,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      viewType: viewType ?? this.viewType,
    );
  }

  @override
  List<Object> get props => [status, products, viewType];
}
