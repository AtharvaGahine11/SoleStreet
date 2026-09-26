import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/address.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  bool _isPlacingOrder = false;
  UserOrder? _lastPlacedOrder;

  List<UserOrder> get orders => _orderService.orders;
  bool get isPlacingOrder => _isPlacingOrder;
  UserOrder? get lastPlacedOrder => _lastPlacedOrder;

  Future<UserOrder?> placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double deliveryFee,
    required double totalAmount,
    required String paymentMethod,
    required DeliveryAddress deliveryAddress,
  }) async {
    _isPlacingOrder = true;
    notifyListeners();

    try {
      final order = await _orderService.placeOrder(
        items: items,
        subtotal: subtotal,
        discount: discount,
        deliveryFee: deliveryFee,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        deliveryAddress: deliveryAddress,
      );
      _lastPlacedOrder = order;
      _isPlacingOrder = false;
      notifyListeners();
      return order;
    } catch (e) {
      _isPlacingOrder = false;
      notifyListeners();
      return null;
    }
  }

  UserOrder? getOrderById(String orderId) {
    return _orderService.getOrderById(orderId);
  }

  void cancelOrder(String orderId) {
    _orderService.cancelOrder(orderId);
    notifyListeners();
  }
}
