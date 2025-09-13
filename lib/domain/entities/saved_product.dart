import 'package:equatable/equatable.dart';

class SavedProduct extends Equatable {
  final String productId;
  final double currentBid;

  const SavedProduct({
    required this.productId,
    required this.currentBid,
  });

  @override
  List<Object> get props => [productId, currentBid];
}

