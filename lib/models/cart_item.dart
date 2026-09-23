import 'product.dart';

class CartItem {
  final Product product;
  String selectedSize;
  String selectedColor;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}
