import 'package:equatable/equatable.dart';

class BiddedProduct extends Equatable {
  final String productId;
  final double currentBid;
  final double yourBid;

  const BiddedProduct({
    required this.productId,
    required this.currentBid,
    required this.yourBid,
  });

  @override
  List<Object> get props => [productId, currentBid, yourBid];
}

