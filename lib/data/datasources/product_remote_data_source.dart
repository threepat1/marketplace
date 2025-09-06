import 'package:marketplace/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> placeBid(String productId, double amount);
}

// Simulated implementation
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _products = [
    ProductModel(
        id: '1',
        name: "Smartphone",
        description: "A powerful Android phone.",
        currentBid: 699.99,
        endTime: DateTime.now().add(const Duration(days: 2)),
        imageUrl:
            "https://cdn.siamphone.com/spec/samsung/images/galaxy_s25/1737729640_03-samsung-galaxy-s25.jpg"),
    // ... other products
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return _products;
  }

  @override
  Future<void> placeBid(String productId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(currentBid: amount);
    }
  }
}
