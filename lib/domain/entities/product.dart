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

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.currentBid,
    required this.endTime,
    required this.imageUrl,
    this.winner,
    this.winningBid,
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
        winner,
        winningBid,
      ];
}
