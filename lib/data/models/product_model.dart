import 'package:equatable/equatable.dart';
import 'package:marketplace/domain/entities/product.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double currentBid;
  final DateTime endTime;
  final String imageUrl;

  /// Stored as path: "Pet/Dog/Corgi/Male"
  final String categoryPath;

  /// NEW FIELDS
  final String createdBy;
  final String province;
  final String postcode;
  final double bidIncrement;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.currentBid,
    required this.endTime,
    required this.imageUrl,
    required this.categoryPath,
    required this.createdBy,
    required this.province,
    required this.postcode,
    required this.bidIncrement,
  });

  /// Model → Entity
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      currentBid: currentBid,
      endTime: endTime,
      imageUrl: imageUrl,
      categories: categoryPath.split("/"),
      createdBy: createdBy,
      province: province,
      postcode: postcode,
      bidIncrement: bidIncrement,
    );
  }

  /// Entity → Model
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      currentBid: product.currentBid,
      endTime: product.endTime,
      imageUrl: product.imageUrl,
      categoryPath: product.categories.join("/"),
      createdBy: product.createdBy,
      province: product.province,
      postcode: product.postcode,
      bidIncrement: product.bidIncrement,
    );
  }
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    DateTime parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is int) {
        try {
          return DateTime.fromMillisecondsSinceEpoch(value);
        } catch (_) {
          return DateTime.fromMillisecondsSinceEpoch(0);
        }
      }
      if (value is String) {
        return DateTime.tryParse(value) ??
            DateTime.fromMillisecondsSinceEpoch(0);
      }
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      currentBid: parseDouble(json['currentBid']),
      endTime: parseDate(json['endTime']),
      imageUrl: json['imageUrl']?.toString() ?? '',
      categoryPath: json['categoryPath']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
      province: json['province']?.toString() ?? '',
      postcode: json['postcode']?.toString() ?? '',
      bidIncrement: parseDouble(json['bidIncrement']),
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'currentBid': currentBid,
      'endTime': endTime.toIso8601String(),
      'imageUrl': imageUrl,
      'categoryPath': categoryPath,
      'createdBy': createdBy,
      'province': province,
      'postcode': postcode,
      'bidIncrement': bidIncrement,
    };
  }

  ProductModel copyWith({
    double? currentBid,
    String? categoryPath,
    String? createdBy,
    String? province,
    String? postcode,
    double? bidIncrement,
  }) {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      currentBid: currentBid ?? this.currentBid,
      endTime: endTime,
      imageUrl: imageUrl,
      categoryPath: categoryPath ?? this.categoryPath,
      createdBy: createdBy ?? this.createdBy,
      province: province ?? this.province,
      postcode: postcode ?? this.postcode,
      bidIncrement: bidIncrement ?? this.bidIncrement,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        currentBid,
        endTime,
        imageUrl,
        categoryPath,
        createdBy,
        province,
        postcode,
        bidIncrement,
      ];
}
