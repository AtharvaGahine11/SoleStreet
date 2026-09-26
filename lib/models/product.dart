import 'review.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String category; // 'necklaces', 'earrings', 'rings', 'bracelets', 'watches', 'bags', 'sunglasses', etc.
  final String gender; // 'women', 'men', 'unisex'
  final String brand;
  final String material; // '18K Gold Plated', '925 Sterling Silver', 'Stainless Steel', 'Italian Leather', etc.
  final String color;
  final List<String> availableColors;
  final List<String> availableSizes;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final bool isNew;
  final bool isTrending;
  final bool isFavorite;
  final int stock;
  final String style; // 'Minimal', 'Classic', 'Luxury', 'Everyday', 'Bold', 'Street', 'Party'
  final List<String> features;
  final List<String> careInstructions;
  final List<ProductReview> reviews;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.category,
    required this.gender,
    required this.brand,
    required this.material,
    required this.color,
    this.availableColors = const [],
    this.availableSizes = const [],
    this.rating = 4.8,
    this.reviewCount = 50,
    required this.images,
    this.isNew = false,
    this.isTrending = false,
    this.isFavorite = false,
    this.stock = 25,
    this.style = 'Minimal',
    this.features = const [
      'Water Resistant',
      'Hypoallergenic',
      'Tarnish Resistant',
      'Premium Handcrafted Finish',
    ],
    this.careInstructions = const [
      'Keep away from harsh chemicals and perfumes',
      'Store in the provided HEERA velvet pouch',
      'Clean gently with soft microfiber cloth',
    ],
    this.reviews = const [],
  });

  double get discountPercent {
    if (originalPrice <= price) return 0;
    return (((originalPrice - price) / originalPrice) * 100).roundToDouble();
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? category,
    String? gender,
    String? brand,
    String? material,
    String? color,
    List<String>? availableColors,
    List<String>? availableSizes,
    double? rating,
    int? reviewCount,
    List<String>? images,
    bool? isNew,
    bool? isTrending,
    bool? isFavorite,
    int? stock,
    String? style,
    List<String>? features,
    List<String>? careInstructions,
    List<ProductReview>? reviews,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      color: color ?? this.color,
      availableColors: availableColors ?? this.availableColors,
      availableSizes: availableSizes ?? this.availableSizes,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      images: images ?? this.images,
      isNew: isNew ?? this.isNew,
      isTrending: isTrending ?? this.isTrending,
      isFavorite: isFavorite ?? this.isFavorite,
      stock: stock ?? this.stock,
      style: style ?? this.style,
      features: features ?? this.features,
      careInstructions: careInstructions ?? this.careInstructions,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'category': category,
      'gender': gender,
      'brand': brand,
      'material': material,
      'color': color,
      'availableColors': availableColors,
      'availableSizes': availableSizes,
      'rating': rating,
      'reviewCount': reviewCount,
      'images': images,
      'isNew': isNew,
      'isTrending': isTrending,
      'isFavorite': isFavorite,
      'stock': stock,
      'style': style,
      'features': features,
      'careInstructions': careInstructions,
      'reviews': reviews.map((r) => r.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (map['originalPrice'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      gender: map['gender'] ?? 'unisex',
      brand: map['brand'] ?? 'HEERA',
      material: map['material'] ?? '',
      color: map['color'] ?? '',
      availableColors: List<String>.from(map['availableColors'] ?? []),
      availableSizes: List<String>.from(map['availableSizes'] ?? []),
      rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: map['reviewCount'] ?? 0,
      images: List<String>.from(map['images'] ?? []),
      isNew: map['isNew'] ?? false,
      isTrending: map['isTrending'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
      stock: map['stock'] ?? 10,
      style: map['style'] ?? 'Minimal',
      features: List<String>.from(map['features'] ?? []),
      careInstructions: List<String>.from(map['careInstructions'] ?? []),
      reviews: (map['reviews'] as List<dynamic>?)
              ?.map((r) => ProductReview.fromMap(r))
              .toList() ??
          [],
    );
  }
}
