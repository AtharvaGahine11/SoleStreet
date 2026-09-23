class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final double price;
  final double originalPrice;
  final double discount;
  final double rating;
  final int reviewCount;
  final String image;
  final List<String> images;
  final List<String> availableSizes;
  final List<String> colors;
  final bool isNew;
  final bool isBestSeller;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.images,
    required this.availableSizes,
    required this.colors,
    this.isNew = false,
    this.isBestSeller = false,
  });

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String get formattedOriginalPrice => '₹${originalPrice.toStringAsFixed(0)}';
  int get discountPercentage => (((originalPrice - price) / originalPrice) * 100).round();
}
