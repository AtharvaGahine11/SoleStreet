import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String selectedColor;
  final String selectedSize;
  final DateTime addedAt;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColor = '',
    this.selectedSize = '',
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  double get totalPrice => product.price * quantity;
  double get totalOriginalPrice => product.originalPrice * quantity;
  double get totalSavings => totalOriginalPrice - totalPrice;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
    DateTime? addedAt,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'] ?? 1,
      selectedColor: map['selectedColor'] ?? '',
      selectedSize: map['selectedSize'] ?? '',
      addedAt: map['addedAt'] != null
          ? DateTime.parse(map['addedAt'])
          : DateTime.now(),
    );
  }
}
