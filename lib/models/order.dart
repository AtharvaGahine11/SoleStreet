import 'cart_item.dart';
import 'address.dart';

enum OrderStatus {
  placed,
  confirmed,
  packed,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.packed:
        return 'Packed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.packed:
        return 2;
      case OrderStatus.shipped:
        return 3;
      case OrderStatus.outForDelivery:
        return 4;
      case OrderStatus.delivered:
        return 5;
      case OrderStatus.cancelled:
        return -1;
    }
  }
}

class TrackingStep {
  final String title;
  final String description;
  final DateTime time;
  final bool isCompleted;

  const TrackingStep({
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'time': time.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory TrackingStep.fromMap(Map<String, dynamic> map) {
    return TrackingStep(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      time: map['time'] != null ? DateTime.parse(map['time']) : DateTime.now(),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

class UserOrder {
  final String id;
  final String orderNumber;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double totalAmount;
  final OrderStatus status;
  final String paymentMethod;
  final DeliveryAddress deliveryAddress;
  final DateTime createdAt;
  final DateTime estimatedDelivery;
  final List<TrackingStep> trackingSteps;

  const UserOrder({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.createdAt,
    required this.estimatedDelivery,
    required this.trackingSteps,
  });

  UserOrder copyWith({
    String? id,
    String? orderNumber,
    List<CartItem>? items,
    double? subtotal,
    double? discount,
    double? deliveryFee,
    double? totalAmount,
    OrderStatus? status,
    String? paymentMethod,
    DeliveryAddress? deliveryAddress,
    DateTime? createdAt,
    DateTime? estimatedDelivery,
    List<TrackingStep>? trackingSteps,
  }) {
    return UserOrder(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      createdAt: createdAt ?? this.createdAt,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      trackingSteps: trackingSteps ?? this.trackingSteps,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'items': items.map((i) => i.toMap()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
      'status': status.name,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'estimatedDelivery': estimatedDelivery.toIso8601String(),
      'trackingSteps': trackingSteps.map((t) => t.toMap()).toList(),
    };
  }

  factory UserOrder.fromMap(Map<String, dynamic> map) {
    return UserOrder(
      id: map['id'] ?? '',
      orderNumber: map['orderNumber'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((i) => CartItem.fromMap(i))
              .toList() ??
          [],
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.placed,
      ),
      paymentMethod: map['paymentMethod'] ?? 'UPI',
      deliveryAddress: DeliveryAddress.fromMap(map['deliveryAddress'] ?? {}),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      estimatedDelivery: map['estimatedDelivery'] != null
          ? DateTime.parse(map['estimatedDelivery'])
          : DateTime.now().add(const Duration(days: 4)),
      trackingSteps: (map['trackingSteps'] as List<dynamic>?)
              ?.map((t) => TrackingStep.fromMap(t))
              .toList() ??
          [],
    );
  }
}
