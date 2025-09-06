import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marketplace/data/model/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Timer _timer;
  Duration _timeRemaining = Duration.zero;
  bool _isAuctionOver = false;
  final TextEditingController _inlineBidController = TextEditingController();

  final String _currentUser = "You";
  String _currentHighestBidder = "No bids yet";

  @override
  void initState() {
    super.initState();
    _startTimer();
    _inlineBidController.text =
        (widget.product.currentBid + 20).toStringAsFixed(2);
  }

  @override
  void dispose() {
    _timer.cancel();
    _inlineBidController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = widget.product.endTime.difference(now);
      if (difference.isNegative) {
        setState(() {
          _isAuctionOver = true;
          widget.product.winner = _currentHighestBidder;
          widget.product.winningBid = widget.product.currentBid;
          _timer.cancel();
        });
      } else {
        setState(() {
          _timeRemaining = difference;
        });
      }
    });
  }

  String _formatTime(Duration duration) {
    if (duration.inDays > 1) {
      return "${duration.inDays} days remaining";
    } else {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final hours = twoDigits(duration.inHours.remainder(24));
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return "$hours:$minutes:$seconds remaining";
    }
  }

  void _placeBid(double newBid) {
    if (!_isAuctionOver && newBid > widget.product.currentBid) {
      setState(() {
        widget.product.currentBid = newBid;
        _currentHighestBidder = _currentUser;
        _inlineBidController.text = (newBid + 20).toStringAsFixed(2);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Bid placed on ${widget.product.name} for \$${newBid.toStringAsFixed(2)}"),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    } else if (newBid <= widget.product.currentBid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your bid must be higher than the current bid."),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(),
            _isAuctionOver
                ? Column(
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
                        "Winner: ${widget.product.winner ?? 'N/A'}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Final Price: \$${widget.product.winningBid?.toStringAsFixed(2) ?? 'N/A'}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatTime(_timeRemaining),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Current Bid: \$${widget.product.currentBid.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _inlineBidController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Your Bid',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final bidAmount =
                                  double.tryParse(_inlineBidController.text);
                              if (bidAmount != null) {
                                _placeBid(bidAmount);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Please enter a valid number."),
                                    duration: Duration(milliseconds: 1500),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                            ),
                            child: const Text("Place Bid"),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
