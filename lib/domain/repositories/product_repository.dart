import 'package:marketplace/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<void> placeBid(String productId, double amount);
}
