import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';
import 'orders_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final OrderItem order;

  const OrderSuccessScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = widget.order;
    final String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(order.orderDate);
    final String formattedEstDelivery = DateFormat('EEEE, dd MMM yyyy').format(order.estimatedDeliveryDate);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Animated Success Badge
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.emeraldGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.emeraldGreen.withValues(alpha: 0.3), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.emeraldGreen.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 64,
                    color: AppTheme.emeraldGreen,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Order Placed Successfully! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Thank you for shopping with SoleStreet. We are preparing your fresh kicks for dispatch.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // Order Breakdown Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration(isDark, borderRadius: 20),
                child: Column(
                  children: [
                    _buildDetailRow('Order ID', order.orderId, isDark, isHighlight: true),
                    Divider(height: 20, color: isDark ? Colors.white10 : Colors.black12),
                    _buildDetailRow('Date', formattedDate, isDark),
                    const SizedBox(height: 10),
                    _buildDetailRow('Total Paid', '₹${order.totalAmount.toStringAsFixed(0)}', isDark, isBold: true),
                    const SizedBox(height: 10),
                    _buildDetailRow('Estimated Delivery', formattedEstDelivery, isDark, isGreen: true),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                      'Delivery Address',
                      '${order.deliveryAddress.fullName} (${order.deliveryAddress.city})',
                      isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OrdersScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryColor, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Track Order',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.4),
                        ),
                        child: const Text(
                          'Continue Shopping',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    bool isDark, {
    bool isHighlight = false,
    bool isBold = false,
    bool isGreen = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold || isHighlight ? FontWeight.bold : FontWeight.w600,
              color: isGreen
                  ? AppTheme.emeraldGreen
                  : (isHighlight
                      ? AppTheme.primaryColor
                      : (isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary)),
            ),
          ),
        ),
      ],
    );
  }
}

