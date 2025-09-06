import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/entities/product.dart';
import 'package:marketplace/domain/repositories/product_repository.dart';

class GetProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await repository.getProducts();
  }
}
