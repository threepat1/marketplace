import 'package:marketplace/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> placeBid(String productId, double amount);
}

// Simulated implementation
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _products = [
    ProductModel(
      id: '1',
      name: "Smartphone",
      description:
          "A powerful Android phone with excellent camera and battery life.",
      currentBid: 699.99,
      endTime: DateTime.now().add(const Duration(days: 2)),
      imageUrl:
          "https://cdn.siamphone.com/spec/samsung/images/galaxy_s25/1737729640_03-samsung-galaxy-s25.jpg",
      categoryPath: "Computers & Electronics/Smartphones/Android",
      createdBy: "user001",
      province: "Bangkok",
      postcode: "10110",
      bidIncrement: 20.0,
    ),
    ProductModel(
      id: '2',
      name: "Vintage Sofa",
      description: "A comfortable vintage leather sofa in great condition.",
      currentBid: 1200.00,
      endTime: DateTime.now().add(const Duration(days: 5)),
      imageUrl:
          "https://www.ikea.com/th/en/images/products/landskrona-sofa__0603365_pe680835_s5.jpg",
      categoryPath: "Furniture/Living Room/Sofas",
      createdBy: "user002",
      province: "Chiang Mai",
      postcode: "50000",
      bidIncrement: 50.0,
    ),
    ProductModel(
      id: '3',
      name: "Corgi Puppy",
      description: "Adorable male corgi puppy looking for a new home.",
      currentBid: 350.00,
      endTime: DateTime.now().add(const Duration(days: 3)),
      imageUrl:
          "https://cdn.britannica.com/55/235755-050-1C5E1F97/Pembroke-Welsh-Corgi-dog.jpg",
      categoryPath: "Pets/Dog/Corgi/Male",
      createdBy: "user003",
      province: "Phuket",
      postcode: "83100",
      bidIncrement: 10.0,
    ),
    ProductModel(
      id: '4',
      name: "Gold Ring",
      description: "18k gold ring with small diamond stones.",
      currentBid: 500.00,
      endTime: DateTime.now().add(const Duration(days: 1)),
      imageUrl: "https://www.tiffany.com/shared/images/tiffany-fav-icon.png",
      categoryPath: "Jewelry, Watches & Gemstones/Rings/Gold",
      createdBy: "user004",
      province: "Khon Kaen",
      postcode: "40000",
      bidIncrement: 25.0,
    ),
    ProductModel(
      id: '5',
      name: "Mountain Bike",
      description: "Durable mountain bike with 21-speed gears.",
      currentBid: 800.00,
      endTime: DateTime.now().add(const Duration(days: 4)),
      imageUrl:
          "https://www.giant-bicycles.com/_upload_th/bikes/models/2022/giant/mountain-bike.jpg",
      categoryPath: "Sporting Goods/Bicycles/Mountain Bike",
      createdBy: "user005",
      province: "Nakhon Ratchasima",
      postcode: "30000",
      bidIncrement: 30.0,
    ),
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return _products;
  }

  @override
  Future<void> placeBid(String productId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(currentBid: amount);
    }
  }
}
