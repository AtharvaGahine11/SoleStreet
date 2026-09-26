import 'package:flutter/material.dart';
import '../models/product.dart';

class CompareProvider extends ChangeNotifier {
  final List<Product> _compareList = [];

  List<Product> get compareList => List.unmodifiable(_compareList);
  bool get hasItems => _compareList.isNotEmpty;

  bool isInCompare(String productId) {
    return _compareList.any((p) => p.id == productId);
  }

  bool toggleCompare(Product product) {
    if (isInCompare(product.id)) {
      _compareList.removeWhere((p) => p.id == product.id);
      notifyListeners();
      return false;
    } else {
      if (_compareList.length >= 3) {
        _compareList.removeAt(0); // Maximum 3 items compared at once
      }
      _compareList.add(product);
      notifyListeners();
      return true;
    }
  }

  void removeFromCompare(String productId) {
    _compareList.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void clearCompare() {
    _compareList.clear();
    notifyListeners();
  }
}
