import 'cart_item.dart';
import 'address.dart';

enum OrderStatus { confirmed, packed, shipped, delivered }

class OrderItem {
  final String orderId;
  final DateTime orderDate;
  final List<CartItem> items;
  final Address deliveryAddress;
  final String deliveryMethod;
  final String paymentMethod;
  final double subtotal;
  final double discountAmount;
  final double deliveryFee;
  final double totalAmount;
  final OrderStatus status;
  final DateTime estimatedDeliveryDate;

  OrderItem({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.deliveryAddress,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.subtotal,
    required this.discountAmount,
    required this.deliveryFee,
    required this.totalAmount,
    this.status = OrderStatus.confirmed,
    required this.estimatedDeliveryDate,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.packed:
        return 'Packed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }
}
