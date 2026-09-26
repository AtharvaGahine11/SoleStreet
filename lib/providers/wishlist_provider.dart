import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_products.dart';
import '../services/storage_service.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _items = [];

  WishlistProvider() {
    _loadWishlist();
  }

  List<Product> get items => List.unmodifiable(_items);
  int get count => _items.length;

  void _loadWishlist() {
    final savedIds = StorageService.getWishlistIds();
    if (savedIds.isNotEmpty) {
      for (final id in savedIds) {
        final prod = DummyData.products.cast<Product?>().firstWhere(
              (p) => p?.id == id,
              orElse: () => null,
            );
        if (prod != null && !_items.any((item) => item.id == prod.id)) {
          _items.add(prod);
        }
      }
    } else {
      // Default initial wishlist items
      _items.addAll(DummyData.products.where((p) => p.isFavorite));
      _saveWishlist();
    }
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _items.any((p) => p.id == productId);
  }

  void toggleWishlist(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }
    _saveWishlist();
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    _items.removeWhere((p) => p.id == productId);
    _saveWishlist();
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    _saveWishlist();
    notifyListeners();
  }

  void _saveWishlist() {
    final ids = _items.map((p) => p.id).toList();
    StorageService.setWishlistIds(ids);
  }
}
