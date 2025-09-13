import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:marketplace/presentation/login/login_page.dart';
import 'package:marketplace/presentation/products/bloc/product_bloc.dart';
import 'package:marketplace/domain/entities/product.dart';
import 'package:marketplace/presentation/profile_form/profile_form.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (previous, current) {
          final previousProduct = previous.products
              .firstWhere((p) => p.id == product.id, orElse: () => product);
          final currentProduct = current.products
              .firstWhere((p) => p.id == product.id, orElse: () => product);
          return previousProduct != currentProduct;
        },
        builder: (context, state) {
          final displayedProduct = state.products.firstWhere(
            (p) => p.id == product.id,
            orElse: () => product,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Image.network(
                  displayedProduct.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  displayedProduct.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  displayedProduct.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 32),

                // NEW: Category, Location, Created By
                Text("Category: ${displayedProduct.fullCategoryPath}"),
                Text("Created by: ${displayedProduct.createdBy}"),
                Text(
                    "Location: ${displayedProduct.province}, ${displayedProduct.postcode}"),
                const Divider(height: 32),

                // Auction section
                _AuctionStatus(product: displayedProduct),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AuctionStatus extends StatelessWidget {
  final Product product;

  const _AuctionStatus({required this.product});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: Stream.periodic(const Duration(seconds: 1), (computationCount) {
        final now = DateTime.now();
        final difference = product.endTime.difference(now);
        return difference.isNegative ? Duration.zero : difference;
      }),
      builder: (context, snapshot) {
        final timeRemaining =
            snapshot.data ?? product.endTime.difference(DateTime.now());
        final isAuctionOver =
            timeRemaining.isNegative || timeRemaining == Duration.zero;

        if (isAuctionOver) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Auction Ended",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(height: 8),
              Text(
                "Final Price: \$${product.currentBid.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatTime(timeRemaining),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 8),
              Text(
                "Current Bid: \$${product.currentBid.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 16),
              _BidSection(product: product),
            ],
          );
        }
      },
    );
  }

  String _formatTime(Duration duration) {
    if (duration.inDays > 1) {
      return "${duration.inDays} days remaining";
    }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds remaining";
  }
}

class _BidSection extends StatelessWidget {
  final Product product;

  const _BidSection({required this.product});

  @override
  Widget build(BuildContext context) {
    final bidController = TextEditingController();
    bidController.text =
        (product.currentBid + product.bidIncrement).toStringAsFixed(2);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: bidController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Your Bid',
              helperText:
                  "Minimum increment: +${product.bidIncrement.toStringAsFixed(2)} ฿",
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            _placeBid(context, bidController.text);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: const Text("Place Bid"),
        ),
      ],
    );
  }

  void _placeBid(BuildContext context, String bidText) {
    final bidAmount = double.tryParse(bidText);
    if (bidAmount != null) {
      if (bidAmount >= product.currentBid + product.bidIncrement) {
        context
            .read<ProductBloc>()
            .add(PlaceBidEvent(productId: product.id, bidAmount: bidAmount));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Your bid must be at least +${product.bidIncrement.toStringAsFixed(2)} higher."),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid number."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
