class Product {
  final String name;
  final String description;
  double currentBid;
  final DateTime endTime;
  final String imageUrl;
  String? winner; // Nullable string for the winner's name
  double? winningBid;

  Product({
    required this.name,
    required this.description,
    required this.currentBid,
    required this.endTime,
    required this.imageUrl,
    this.winner,
    this.winningBid,
  });
}
