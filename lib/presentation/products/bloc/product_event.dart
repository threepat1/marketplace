part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class PlaceBidEvent extends ProductEvent {
  final String productId;
  final double bidAmount;
  const PlaceBidEvent({required this.productId, required this.bidAmount});
  @override
  List<Object> get props => [productId, bidAmount];
}

// 1. DEFINE THE MISSING ToggleViewEvent CLASS HERE
class ToggleViewEvent extends ProductEvent {}
