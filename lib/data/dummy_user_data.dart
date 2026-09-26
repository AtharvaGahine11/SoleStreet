import '../models/user.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/notification_item.dart';
import 'dummy_products.dart';

class DummyUserData {
  static final DeliveryAddress defaultAddress = DeliveryAddress(
    id: 'addr_01',
    fullName: 'Atharva S.',
    phone: '+91 98765 43210',
    streetAddress: 'Flat 402, Lotus Grand Residences, 18th Main Road',
    locality: 'Indiranagar',
    city: 'Bengaluru',
    state: 'Karnataka',
    pincode: '560038',
    type: 'Home',
    isDefault: true,
  );

  static final DeliveryAddress officeAddress = DeliveryAddress(
    id: 'addr_02',
    fullName: 'Atharva S.',
    phone: '+91 98765 43210',
    streetAddress: 'Level 5, WeWork Prestige Tech Park, Marathahalli Ring Rd',
    locality: 'Kadubeesanahalli',
    city: 'Bengaluru',
    state: 'Karnataka',
    pincode: '560103',
    type: 'Work',
    isDefault: false,
  );

  static final UserProfile defaultProfile = UserProfile(
    id: 'usr_atharva_01',
    name: 'Atharva S.',
    email: 'atharva@heera.luxury',
    phone: '+91 98765 43210',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    addresses: [defaultAddress, officeAddress],
    defaultAddressId: 'addr_01',
    joinedDate: DateTime(2025, 3, 14),
  );

  static final List<UserOrder> sampleOrders = [
    UserOrder(
      id: 'ord_10284',
      orderNumber: 'HR10284',
      items: [
        CartItem(
          product: DummyData.products[0], // Aurelia Minimal Snake Chain
          quantity: 1,
          selectedColor: 'Champagne Gold',
          selectedSize: '16 inch',
        ),
        CartItem(
          product: DummyData.products[2], // Chronos Obsidian Watch
          quantity: 1,
          selectedColor: 'Matte Obsidian',
          selectedSize: '40mm Dial',
        ),
      ],
      subtotal: 4998,
      discount: 500,
      deliveryFee: 0,
      totalAmount: 4498,
      status: OrderStatus.outForDelivery,
      paymentMethod: 'UPI (Google Pay)',
      deliveryAddress: defaultAddress,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      estimatedDelivery: DateTime.now().add(const Duration(days: 1)),
      trackingSteps: [
        TrackingStep(
          title: 'Order Placed',
          description: 'Your order was successfully verified and confirmed.',
          time: DateTime.now().subtract(const Duration(days: 2)),
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Packed at Atelier',
          description: 'Handcrafted luxury velvet box packaging completed.',
          time: DateTime.now().subtract(const Duration(days: 1, hours: 14)),
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Shipped via BlueDart Express',
          description: 'Package departed Bengaluru Hub (AWB #BL8849201).',
          time: DateTime.now().subtract(const Duration(hours: 18)),
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Out for Delivery',
          description: 'Courier partner is arriving at your Indiranagar location today.',
          time: DateTime.now().subtract(const Duration(hours: 2)),
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Delivered',
          description: 'Package handed over with OTP verification.',
          time: DateTime.now().add(const Duration(days: 1)),
          isCompleted: false,
        ),
      ],
    ),
    UserOrder(
      id: 'ord_10190',
      orderNumber: 'HR10190',
      items: [
        CartItem(
          product: DummyData.products[1], // Celeste Freshwater Pearl Hoops
          quantity: 1,
          selectedColor: 'Pearl & Gold',
          selectedSize: 'One Size',
        ),
      ],
      subtotal: 1899,
      discount: 200,
      deliveryFee: 0,
      totalAmount: 1699,
      status: OrderStatus.delivered,
      paymentMethod: 'Credit Card (•••• 8821)',
      deliveryAddress: defaultAddress,
      createdAt: DateTime.now().subtract(const Duration(days: 18)),
      estimatedDelivery: DateTime.now().subtract(const Duration(days: 14)),
      trackingSteps: [
        TrackingStep(
          title: 'Order Placed',
          description: 'Order confirmed and payment verified.',
          time: DateTime.now().subtract(const Duration(days: 18)),
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Delivered',
          description: 'Delivered to Atharva S. at Indiranagar.',
          time: DateTime.now().subtract(const Duration(days: 14)),
          isCompleted: true,
        ),
      ],
    ),
  ];

  static final List<NotificationItem> sampleNotifications = [
    NotificationItem(
      id: 'notif_01',
      title: '✨ Autumn Haute Joaillerie Dropped',
      message: 'Explore our latest 18K solid vermeil choker and cuff collection.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: 'promo',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif_02',
      title: '📦 Order #LM10284 Out for Delivery',
      message: 'Your BlueDart express package is arriving today before 6 PM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: 'order',
      isRead: false,
    ),
    NotificationItem(
      id: 'notif_03',
      title: '♡ Wishlist Price Drop Alert!',
      message: 'Aurelia Minimal Snake Chain is now 32% OFF for a limited time.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'wishlist',
      isRead: true,
    ),
    NotificationItem(
      id: 'notif_04',
      title: '🎁 Exclusive Member Perk',
      message: 'Use code STYLE20 at checkout for flat 20% savings on orders above ₹2,499.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: 'promo',
      isRead: true,
    ),
  ];
}
