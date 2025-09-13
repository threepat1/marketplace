import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double currentBid;
  final DateTime endTime;
  final String imageUrl;
  final String? winner;
  final double? winningBid;

  /// Hierarchical categories
  final List<String> categories;

  /// NEW FIELDS
  final String createdBy; // user id or name
  final String province;
  final String postcode;
  final double bidIncrement;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.currentBid,
    required this.endTime,
    required this.imageUrl,
    this.winner,
    this.winningBid,
    required this.categories,
    required this.createdBy,
    required this.province,
    required this.postcode,
    required this.bidIncrement,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? currentBid,
    DateTime? endTime,
    String? imageUrl,
    String? winner,
    double? winningBid,
    List<String>? categories,
    String? createdBy,
    String? province,
    String? postcode,
    double? bidIncrement,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      currentBid: currentBid ?? this.currentBid,
      endTime: endTime ?? this.endTime,
      imageUrl: imageUrl ?? this.imageUrl,
      winner: winner ?? this.winner,
      winningBid: winningBid ?? this.winningBid,
      categories: categories ?? this.categories,
      createdBy: createdBy ?? this.createdBy,
      province: province ?? this.province,
      postcode: postcode ?? this.postcode,
      bidIncrement: bidIncrement ?? this.bidIncrement,
    );
  }

  String get fullCategoryPath => categories.join(" > ");

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        currentBid,
        endTime,
        imageUrl,
        winner,
        winningBid,
        categories,
        createdBy,
        province,
        postcode,
        bidIncrement,
      ];
}
