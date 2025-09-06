import 'package:marketplace/data/datasources/product_remote_data_source.dart';
import 'package:marketplace/domain/entities/product.dart';
import 'package:marketplace/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    final productModels = await remoteDataSource.getProducts();
    // This line will now compile and run successfully!
    return productModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> placeBid(String productId, double amount) {
    // This part remains the same
    return remoteDataSource.placeBid(productId, amount);
  }
}
