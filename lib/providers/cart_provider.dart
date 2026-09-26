import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/coupon.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<CartItem> get items => _cartService.items;
  List<Product> get savedForLater => _cartService.savedForLater;
  Coupon? get appliedCoupon => _cartService.appliedCoupon;

  int get itemCount => _cartService.itemCount;
  double get subtotal => _cartService.subtotal;
  double get originalSubtotal => _cartService.originalSubtotal;
  double get productSavings => _cartService.productSavings;
  double get couponDiscount => _cartService.couponDiscount;
  double get deliveryFee => _cartService.deliveryFee;
  double get totalAmount => _cartService.totalAmount;

  bool get isEmpty => items.isEmpty;

  void addToCart(Product product, {int quantity = 1, String? color, String? size}) {
    _cartService.addToCart(product, quantity: quantity, color: color, size: size);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity, {String? color, String? size}) {
    _cartService.updateQuantity(productId, newQuantity, color: color, size: size);
    notifyListeners();
  }

  void removeFromCart(String productId, {String? color, String? size}) {
    _cartService.removeFromCart(productId, color: color, size: size);
    notifyListeners();
  }

  void saveForLater(CartItem item) {
    _cartService.saveForLater(item);
    notifyListeners();
  }

  void moveToCart(Product product) {
    _cartService.moveToCart(product);
    notifyListeners();
  }

  void removeSavedForLater(String productId) {
    _cartService.removeSavedForLater(productId);
    notifyListeners();
  }

  bool applyCoupon(String code) {
    final success = _cartService.applyCoupon(code);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  void removeCoupon() {
    _cartService.removeCoupon();
    notifyListeners();
  }

  void clearCart() {
    _cartService.clearCart();
    notifyListeners();
  }
}
