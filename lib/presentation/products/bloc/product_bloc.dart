import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/entities/product.dart';
import 'package:marketplace/domain/usecases/get_products.dart';
import 'package:marketplace/domain/usecases/place_bid.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final PlaceBid placeBid;

  // The constructor is the "Training Manual"
  ProductBloc({required this.getProducts, required this.placeBid})
      : super(const ProductState()) {
    // Each 'on<Event>' is a page of instructions in the manual.
    on<LoadProducts>(_onLoadProducts);
    on<PlaceBidEvent>(_onPlaceBid);

    on<SetViewTypeEvent>(_onSetViewType);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await getProducts(NoParams());
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<void> _onPlaceBid(
      PlaceBidEvent event, Emitter<ProductState> emit) async {
    try {
      await placeBid(
          PlaceBidParams(productId: event.productId, amount: event.bidAmount));
      add(LoadProducts());
    } catch (_) {
      // Handle potential bidding errors here if necessary
    }
  }

  void _onSetViewType(SetViewTypeEvent event, Emitter<ProductState> emit) {
    emit(state.copyWith(viewType: event.viewType));
  }
}
