import '../models/product.dart';
import '../models/category.dart';
import '../data/dummy_products.dart';

class ProductFilterOptions {
  final String? gender; // 'women', 'men', 'unisex', null
  final String? category;
  final String? style;
  final double? minPrice;
  final double? maxPrice;
  final String? material;
  final String? color;
  final double? minRating;
  final String? sortBy; // 'recommended', 'newest', 'price_low_high', 'price_high_low', 'rating', 'popularity'

  const ProductFilterOptions({
    this.gender,
    this.category,
    this.style,
    this.minPrice,
    this.maxPrice,
    this.material,
    this.color,
    this.minRating,
    this.sortBy = 'recommended',
  });

  ProductFilterOptions copyWith({
    String? gender,
    String? category,
    String? style,
    double? minPrice,
    double? maxPrice,
    String? material,
    String? color,
    double? minRating,
    String? sortBy,
  }) {
    return ProductFilterOptions(
      gender: gender ?? this.gender,
      category: category ?? this.category,
      style: style ?? this.style,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      material: material ?? this.material,
      color: color ?? this.color,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class ProductService {
  List<Product> getProducts({ProductFilterOptions? filters}) {
    List<Product> results = List.from(DummyData.products);

    if (filters != null) {
      if (filters.gender != null && filters.gender != 'all') {
        results = results.where((p) => p.gender == filters.gender || p.gender == 'unisex').toList();
      }

      if (filters.category != null && filters.category != 'all') {
        results = results.where((p) => p.category.toLowerCase() == filters.category!.toLowerCase()).toList();
      }

      if (filters.style != null && filters.style != 'All') {
        results = results.where((p) => p.style.toLowerCase() == filters.style!.toLowerCase()).toList();
      }

      if (filters.minPrice != null) {
        results = results.where((p) => p.price >= filters.minPrice!).toList();
      }

      if (filters.maxPrice != null) {
        results = results.where((p) => p.price <= filters.maxPrice!).toList();
      }

      if (filters.material != null && filters.material != 'All') {
        results = results.where((p) => p.material.toLowerCase().contains(filters.material!.toLowerCase())).toList();
      }

      if (filters.color != null && filters.color != 'All') {
        results = results.where((p) => p.color.toLowerCase().contains(filters.color!.toLowerCase()) ||
          p.availableColors.any((c) => c.toLowerCase().contains(filters.color!.toLowerCase()))).toList();
      }

      if (filters.minRating != null) {
        results = results.where((p) => p.rating >= filters.minRating!).toList();
      }

      // Sorting
      switch (filters.sortBy) {
        case 'newest':
          results.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
          break;
        case 'price_low_high':
          results.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_high_low':
          results.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'rating':
          results.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'popularity':
          results.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
          break;
        default:
          // 'recommended'
          results.sort((a, b) => (b.isTrending ? 1 : 0).compareTo(a.isTrending ? 1 : 0));
          break;
      }
    }

    return results;
  }

  Product? getProductById(String id) {
    try {
      return DummyData.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Product> getTrendingProducts() {
    return DummyData.products.where((p) => p.isTrending).toList();
  }

  List<Product> getNewArrivals() {
    return DummyData.products.where((p) => p.isNew).toList();
  }

  List<Product> getPickedForYou({String? preferenceCategory}) {
    if (preferenceCategory != null) {
      final preferred = DummyData.products.where((p) => p.category == preferenceCategory).toList();
      if (preferred.isNotEmpty) return preferred;
    }
    return DummyData.products.where((p) => p.rating >= 4.8).toList();
  }

  List<Product> getRelatedProducts(Product product) {
    return DummyData.products
        .where((p) => p.id != product.id && (p.category == product.category || p.gender == product.gender))
        .take(6)
        .toList();
  }

  List<Product> searchProducts(String query) {
    if (query.trim().isEmpty) return [];
    final cleanQuery = query.toLowerCase().trim();
    return DummyData.products.where((p) {
      return p.name.toLowerCase().contains(cleanQuery) ||
          p.brand.toLowerCase().contains(cleanQuery) ||
          p.description.toLowerCase().contains(cleanQuery) ||
          p.category.toLowerCase().contains(cleanQuery) ||
          p.material.toLowerCase().contains(cleanQuery) ||
          p.style.toLowerCase().contains(cleanQuery);
    }).toList();
  }

  List<ProductCategory> getCategories({String? gender}) {
    if (gender == null || gender == 'all') {
      return DummyData.categories;
    }
    return DummyData.categories.where((c) => c.gender == 'all' || c.gender == gender).toList();
  }
}
