import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/coupon.dart';
import '../utils/constants.dart';
import '../data/dummy_products.dart';

class CartService {
  final List<CartItem> _items = [
    CartItem(
      product: DummyData.products[0], // Aurelia Snake Chain
      quantity: 1,
      selectedColor: 'Champagne Gold',
      selectedSize: '16 inch',
    ),
    CartItem(
      product: DummyData.products[2], // Chronos Watch
      quantity: 1,
      selectedColor: 'Matte Obsidian',
      selectedSize: '40mm Dial',
    ),
  ];

  final List<Product> _savedForLater = [];
  Coupon? _appliedCoupon;

  List<CartItem> get items => List.unmodifiable(_items);
  List<Product> get savedForLater => List.unmodifiable(_savedForLater);
  Coupon? get appliedCoupon => _appliedCoupon;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get originalSubtotal => _items.fold(0.0, (sum, item) => sum + item.totalOriginalPrice);
  double get productSavings => originalSubtotal - subtotal;

  double get couponDiscount {
    if (_appliedCoupon == null) return 0.0;
    return _appliedCoupon!.calculateDiscount(subtotal);
  }

  double get deliveryFee {
    if (subtotal == 0) return 0.0;
    if (subtotal >= AppConstants.freeDeliveryThreshold) return 0.0;
    return AppConstants.standardDeliveryFee;
  }

  double get totalAmount {
    if (subtotal == 0) return 0.0;
    return (subtotal - couponDiscount + deliveryFee).clamp(0.0, double.infinity);
  }

  void addToCart(Product product, {int quantity = 1, String? color, String? size}) {
    final chosenColor = color ?? (product.availableColors.isNotEmpty ? product.availableColors.first : product.color);
    final chosenSize = size ?? (product.availableSizes.isNotEmpty ? product.availableSizes.first : 'Standard');

    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor == chosenColor &&
          item.selectedSize == chosenSize,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        quantity: quantity,
        selectedColor: chosenColor,
        selectedSize: chosenSize,
      ));
    }
  }

  void updateQuantity(String productId, int newQuantity, {String? color, String? size}) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == productId &&
          (color == null || item.selectedColor == color) &&
          (size == null || item.selectedSize == size),
    );

    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
    }
  }

  void removeFromCart(String productId, {String? color, String? size}) {
    _items.removeWhere(
      (item) =>
          item.product.id == productId &&
          (color == null || item.selectedColor == color) &&
          (size == null || item.selectedSize == size),
    );
  }

  void saveForLater(CartItem item) {
    _items.remove(item);
    if (!_savedForLater.any((p) => p.id == item.product.id)) {
      _savedForLater.add(item.product);
    }
  }

  void moveToCart(Product product) {
    _savedForLater.removeWhere((p) => p.id == product.id);
    addToCart(product);
  }

  void removeSavedForLater(String productId) {
    _savedForLater.removeWhere((p) => p.id == productId);
  }

  bool applyCoupon(String code) {
    try {
      final match = DummyData.coupons.firstWhere(
        (c) => c.code.toUpperCase() == code.trim().toUpperCase(),
      );
      _appliedCoupon = match;
      return true;
    } catch (_) {
      return false;
    }
  }

  void removeCoupon() {
    _appliedCoupon = null;
  }

  void clearCart() {
    _items.clear();
    _appliedCoupon = null;
  }
}
