import 'package:equatable/equatable.dart';
import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/repositories/product_repository.dart';

class PlaceBid implements UseCase<void, PlaceBidParams> {
  final ProductRepository repository;
  PlaceBid(this.repository);

  @override
  Future<void> call(PlaceBidParams params) async {
    return await repository.placeBid(params.productId, params.amount);
  }
}

class PlaceBidParams extends Equatable {
  final String productId;
  final double amount;

  const PlaceBidParams({required this.productId, required this.amount});

  @override
  List<Object?> get props => [productId, amount];
}
