import 'package:equatable/equatable.dart';
import 'package:marketplace/domain/entities/product.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double currentBid;
  final DateTime endTime;
  final String imageUrl;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.currentBid,
    required this.endTime,
    required this.imageUrl,
  });

  // 1. ADD THIS METHOD TO CONVERT THE MODEL TO A DOMAIN ENTITY
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      currentBid: currentBid,
      endTime: endTime,
      imageUrl: imageUrl,
      // The winner and winningBid fields are not part of the model,
      // so they will be null by default in the entity, which is correct.
    );
  }

  // 2. (BEST PRACTICE) ADD A FACTORY FOR CONVERTING FROM AN ENTITY
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      currentBid: product.currentBid,
      endTime: product.endTime,
      imageUrl: product.imageUrl,
    );
  }

  ProductModel copyWith({double? currentBid}) {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      currentBid: currentBid ?? this.currentBid,
      endTime: endTime,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, currentBid, endTime, imageUrl];
}
