import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:marketplace/presentation/products/bloc/product_bloc.dart';
import 'package:marketplace/domain/entities/product.dart';
import 'package:marketplace/presentation/login/login_page.dart';
import 'package:marketplace/presentation/products/product_detail_page.dart';

class BiddingProductView extends StatefulWidget {
  final Product product;
  final bool isGridView;

  const BiddingProductView({
    super.key,
    required this.product,
    this.isGridView = false,
  });

  @override
  State<BiddingProductView> createState() => _BiddingProductViewState();
}

class _BiddingProductViewState extends State<BiddingProductView> {
  // Timer logic remains the same
  late Timer _timer;
  Duration _timeRemaining = Duration.zero;
  bool _isAuctionOver = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    final initialDifference = widget.product.endTime.difference(DateTime.now());
    if (initialDifference.isNegative) {
      _isAuctionOver = true;
    } else {
      _timeRemaining = initialDifference;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final difference = widget.product.endTime.difference(DateTime.now());
      if (mounted) {
        setState(() {
          if (difference.isNegative) {
            _isAuctionOver = true;
            _timeRemaining = Duration.zero;
            timer.cancel();
          } else {
            _timeRemaining = difference;
          }
        });
      }
    });
  }

  String _formatTime(Duration duration) {
    if (duration.inDays > 1) {
      return "${duration.inDays} days";
    }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: widget.product),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: widget.isGridView
            ? _buildGridCard(context)
            : _buildListTile(context),
      ),
    );
  }

  Widget _buildTimeRemainingText() {
    return Text(
      _isAuctionOver
          ? "Auction ended"
          : "${_formatTime(_timeRemaining)} remaining",
      style: TextStyle(
        color: _isAuctionOver ? Colors.red : Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      leading: Image.network(widget.product.imageUrl, width: 50, height: 50),
      title: Text(widget.product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.description),
          _buildTimeRemainingText(),
        ],
      ),
      trailing:
          _BidSection(product: widget.product, isAuctionOver: _isAuctionOver),
    );
  }

  Widget _buildGridCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image.network(
            widget.product.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.product.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "\$${widget.product.currentBid.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.green),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: _buildTimeRemainingText(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _BidSection(
              product: widget.product, isAuctionOver: _isAuctionOver),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _BidSection extends StatelessWidget {
  final Product product;
  final bool isAuctionOver;

  const _BidSection({required this.product, required this.isAuctionOver});

  @override
  Widget build(BuildContext context) {
    if (isAuctionOver) {
      return const SizedBox.shrink();
    }
    final bidController = TextEditingController();
    bidController.text = (product.currentBid + 20).toStringAsFixed(2);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          child: TextField(
            controller: bidController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              border: OutlineInputBorder(),
              labelText: 'Bid',
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            final authState = context.read<AuthenticationBloc>().state;
            if (authState is AuthenticationAuthenticated) {
              _placeBid(context, bidController.text);
            } else {
              final loginSuccess = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
              if (loginSuccess == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Login Successful! You can now place your bid.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          },
          child: const Text("Bid"),
        ),
      ],
    );
  }

  void _placeBid(BuildContext context, String bidText) {
    final bidAmount = double.tryParse(bidText);
    if (bidAmount != null) {
      if (bidAmount > product.currentBid) {
        // THIS IS THE CORRECTED LINE
        context
            .read<ProductBloc>()
            .add(PlaceBidEvent(productId: product.id, bidAmount: bidAmount));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your bid must be higher than the current bid."),
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
