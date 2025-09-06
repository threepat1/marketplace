import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marketplace/data/model/product.dart';
import 'package:marketplace/product_detail_page.dart';

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
  late Timer _timer;
  Duration _timeRemaining = Duration.zero;
  bool _isAuctionOver = false;
  final TextEditingController _inlineBidController = TextEditingController();

  // A dummy user to simulate a winning user. In a real app, this would be a logged-in user.
  final String _currentUser = "You";
  // A variable to track who has the current highest bid.
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
          // Set the winner and winning bid when the auction ends.
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
        _currentHighestBidder =
            _currentUser; // Assuming the current user places the bid.
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
        child: widget.isGridView ? _buildGridCard() : _buildListTile(),
      ),
    );
  }

  Widget _buildListTile() {
    return ListTile(
      leading: Image.network(widget.product.imageUrl, width: 50, height: 50),
      title: Text(widget.product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.description),
          Text(
            _isAuctionOver ? "Auction ended" : _formatTime(_timeRemaining),
            style: TextStyle(
              color: _isAuctionOver ? Colors.red : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: _isAuctionOver
          ? _buildAuctionEndedView() // Show winner info
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _inlineBidController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      labelText: 'Bid',
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
                          content: Text("Please enter a valid number."),
                          duration: Duration(milliseconds: 1500),
                        ),
                      );
                    }
                  },
                  child: const Text("Bid"),
                ),
              ],
            ),
    );
  }

  Widget _buildGridCard() {
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
          child: Text(
            _isAuctionOver ? "Auction ended" : _formatTime(_timeRemaining),
            style: TextStyle(
              color: _isAuctionOver ? Colors.red : Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        if (!_isAuctionOver)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inlineBidController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                      labelText: 'Bid',
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
                          content: Text("Please enter a valid number."),
                          duration: Duration(milliseconds: 1500),
                        ),
                      );
                    }
                  },
                  child: const Text("Bid"),
                ),
              ],
            ),
          )
        else
          _buildAuctionEndedView(), // Show winner info
        const SizedBox(height: 8),
      ],
    );
  }

  // New method to build the view after the auction has ended.
  Widget _buildAuctionEndedView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Winner: ${widget.product.winner ?? 'N/A'}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Final Price: \$${widget.product.winningBid?.toStringAsFixed(2) ?? 'N/A'}",
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.purple),
        ),
      ],
    );
  }
}
