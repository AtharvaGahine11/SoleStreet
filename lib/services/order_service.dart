import 'dart:math';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/address.dart';
import '../data/dummy_user_data.dart';

class OrderService {
  final List<UserOrder> _orders = List.from(DummyUserData.sampleOrders);

  List<UserOrder> get orders => List.unmodifiable(_orders);

  Future<UserOrder> placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double deliveryFee,
    required double totalAmount,
    required String paymentMethod,
    required DeliveryAddress deliveryAddress,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final randomNum = 10000 + Random().nextInt(89999);
    final orderNumber = 'LM$randomNum';
    final now = DateTime.now();
    final estimatedDate = now.add(const Duration(days: 4));

    final newOrder = UserOrder(
      id: 'ord_$randomNum',
      orderNumber: orderNumber,
      items: List.from(items),
      subtotal: subtotal,
      discount: discount,
      deliveryFee: deliveryFee,
      totalAmount: totalAmount,
      status: OrderStatus.placed,
      paymentMethod: paymentMethod,
      deliveryAddress: deliveryAddress,
      createdAt: now,
      estimatedDelivery: estimatedDate,
      trackingSteps: [
        TrackingStep(
          title: 'Order Placed',
          description: 'Your payment via $paymentMethod has been authorized.',
          time: now,
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Order Confirmed',
          description: 'Our atelier is preparing your bespoke items.',
          time: now.add(const Duration(minutes: 30)),
          isCompleted: false,
        ),
        TrackingStep(
          title: 'Packed in Luxury Gift Box',
          description: 'Carefully cushioned with velvet pouch and seal of authenticity.',
          time: now.add(const Duration(days: 1)),
          isCompleted: false,
        ),
        TrackingStep(
          title: 'Shipped via Express Courier',
          description: 'Handed over to logistics with live tracking.',
          time: now.add(const Duration(days: 2)),
          isCompleted: false,
        ),
        TrackingStep(
          title: 'Delivered',
          description: 'Delivered to ${deliveryAddress.fullName}.',
          time: estimatedDate,
          isCompleted: false,
        ),
      ],
    );

    _orders.insert(0, newOrder);
    return newOrder;
  }

  UserOrder? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId || o.orderNumber == orderId);
    } catch (_) {
      return null;
    }
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: OrderStatus.cancelled);
    }
  }
}
