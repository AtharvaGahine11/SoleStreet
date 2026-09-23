import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../data/product_data.dart';

class AppState with ChangeNotifier {
  // Theme State
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // Master Products
  final List<Product> _allProducts = ProductData.sampleProducts;
  List<Product> get allProducts => _allProducts;

  // Wishlist State
  final Set<String> _wishlistIds = {'p1', 'p3', 'p9'};
  Set<String> get wishlistIds => _wishlistIds;

  List<Product> get wishlistProducts {
    return _allProducts.where((p) => _wishlistIds.contains(p.id)).toList();
  }

  bool isInWishlist(String productId) {
    return _wishlistIds.contains(productId);
  }

  void toggleWishlist(Product product) {
    if (_wishlistIds.contains(product.id)) {
      _wishlistIds.remove(product.id);
    } else {
      _wishlistIds.add(product.id);
    }
    notifyListeners();
  }

  // Cart State
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  int get cartCount {
    int count = 0;
    for (var item in _cart) {
      count += item.quantity;
    }
    return count;
  }

  void addToCart(Product product, String size, String color, {int quantity = 1}) {
    // Check if item with same product ID, size, and color already exists in cart
    final index = _cart.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (index >= 0) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColor: color,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void updateCartQuantity(int index, int delta) {
    if (index >= 0 && index < _cart.length) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cart.length) {
      _cart.removeAt(index);
      notifyListeners();
    }
  }

  void moveWishlistItemToCart(Product product) {
    String size = product.availableSizes.isNotEmpty ? product.availableSizes.first : 'UK 8';
    String color = product.colors.isNotEmpty ? product.colors.first : 'Default';
    addToCart(product, size, color);
    _wishlistIds.remove(product.id);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _appliedCoupon = null;
    notifyListeners();
  }

  // Coupon Engine
  String? _appliedCoupon;
  String? get appliedCoupon => _appliedCoupon;
  double _couponDiscountPercentage = 0.0;

  final Map<String, double> _validCoupons = {
    'SOLE10': 0.10,
    'NEWUSER': 0.15,
    'KICK20': 0.20,
  };

  Map<String, dynamic> applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (_validCoupons.containsKey(cleanCode)) {
      _appliedCoupon = cleanCode;
      _couponDiscountPercentage = _validCoupons[cleanCode]!;
      notifyListeners();
      return {
        'success': true,
        'message': 'Coupon $cleanCode applied! (${(_couponDiscountPercentage * 100).round()}% OFF)',
      };
    } else {
      return {
        'success': false,
        'message': 'Invalid or expired coupon code.',
      };
    }
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _couponDiscountPercentage = 0.0;
    notifyListeners();
  }

  // Price Calculations
  double get cartSubtotal {
    double subtotal = 0;
    for (var item in _cart) {
      subtotal += item.totalPrice;
    }
    return subtotal;
  }

  double get couponDiscountAmount {
    return cartSubtotal * _couponDiscountPercentage;
  }

  double get deliveryFee {
    if (_cart.isEmpty) return 0;
    if (cartSubtotal >= 5000) return 0; // Free delivery over ₹5000
    return 99;
  }

  double get cartGrandTotal {
    if (_cart.isEmpty) return 0;
    return cartSubtotal - couponDiscountAmount + deliveryFee;
  }

  // Search & Filter State
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String? _selectedPriceRange;
  String? get selectedPriceRange => _selectedPriceRange;

  double _selectedMinRating = 0.0;
  double get selectedMinRating => _selectedMinRating;

  String _sortBy = 'Popular';
  String get sortBy => _sortBy;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setPriceRange(String? range) {
    _selectedPriceRange = range;
    notifyListeners();
  }

  void setMinRating(double rating) {
    _selectedMinRating = rating;
    notifyListeners();
  }

  void setSortBy(String sortOption) {
    _sortBy = sortOption;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedPriceRange = null;
    _selectedMinRating = 0.0;
    _sortBy = 'Popular';
    notifyListeners();
  }

  // Filtered Products Calculation
  List<Product> get filteredProducts {
    return _allProducts.where((product) {
      // 1. Search Query Filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = product.name.toLowerCase().contains(query);
        final matchesBrand = product.brand.toLowerCase().contains(query);
        final matchesCategory = product.category.toLowerCase().contains(query);
        if (!matchesName && !matchesBrand && !matchesCategory) {
          return false;
        }
      }

      // 2. Category Filter
      if (_selectedCategory != 'All' &&
          product.category.toLowerCase() != _selectedCategory.toLowerCase()) {
        return false;
      }

      // 3. Price Range Filter
      if (_selectedPriceRange != null) {
        if (_selectedPriceRange == 'Under ₹2,000' && product.price >= 2000) {
          return false;
        } else if (_selectedPriceRange == '₹2,000–₹5,000' &&
            (product.price < 2000 || product.price > 5000)) {
          return false;
        } else if (_selectedPriceRange == '₹5,000–₹10,000' &&
            (product.price < 5000 || product.price > 10000)) {
          return false;
        } else if (_selectedPriceRange == 'Above ₹10,000' && product.price <= 10000) {
          return false;
        }
      }

      // 4. Rating Filter
      if (product.rating < _selectedMinRating) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        switch (_sortBy) {
          case 'Price: Low to High':
            return a.price.compareTo(b.price);
          case 'Price: High to Low':
            return b.price.compareTo(a.price);
          case 'Rating':
            return b.rating.compareTo(a.rating);
          case 'Newest':
            return (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0);
          case 'Popular':
          default:
            return b.reviewCount.compareTo(a.reviewCount);
        }
      });
  }

  // Orders Engine
  final List<OrderItem> _orders = [
    OrderItem(
      orderId: 'SS-982145',
      orderDate: DateTime.now().subtract(const Duration(days: 3)),
      items: [
        CartItem(
          product: ProductData.sampleProducts[0],
          selectedSize: 'UK 9',
          selectedColor: 'Red',
          quantity: 1,
        ),
      ],
      deliveryAddress: Address(
        fullName: 'Rahul Sharma',
        mobileNumber: '+91 98765 43210',
        houseFlat: 'Flat 402, Skyline Towers',
        street: 'MG Road, Indiranagar',
        city: 'Bengaluru',
        state: 'Karnataka',
        pinCode: '560038',
      ),
      deliveryMethod: 'Express Delivery',
      paymentMethod: 'UPI',
      subtotal: 8995,
      discountAmount: 899.5,
      deliveryFee: 149,
      totalAmount: 8244.5,
      status: OrderStatus.shipped,
      estimatedDeliveryDate: DateTime.now().add(const Duration(days: 1)),
    ),
  ];

  List<OrderItem> get orders => _orders;

  OrderItem placeOrder({
    required Address address,
    required String deliveryMethod,
    required String paymentMethod,
    required double deliveryFeeChoice,
  }) {
    final String newOrderId = 'SS-${(100000 + (DateTime.now().millisecondsSinceEpoch % 899999)).toString()}';
    final DateTime now = DateTime.now();
    final DateTime estDelivery = now.add(Duration(days: deliveryMethod.contains('Express') ? 2 : 4));

    final OrderItem newOrder = OrderItem(
      orderId: newOrderId,
      orderDate: now,
      items: List.from(_cart),
      deliveryAddress: address,
      deliveryMethod: deliveryMethod,
      paymentMethod: paymentMethod,
      subtotal: cartSubtotal,
      discountAmount: couponDiscountAmount,
      deliveryFee: deliveryFeeChoice,
      totalAmount: cartSubtotal - couponDiscountAmount + deliveryFeeChoice,
      status: OrderStatus.confirmed,
      estimatedDeliveryDate: estDelivery,
    );

    _orders.insert(0, newOrder);
    clearCart();
    notifyListeners();
    return newOrder;
  }
}
