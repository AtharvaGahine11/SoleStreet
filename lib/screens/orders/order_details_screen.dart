import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../models/order.dart';
import '../../utils/helpers.dart';
import '../../providers/order_provider.dart';
import '../../widgets/lumora_image.dart';
import '../../widgets/custom_button.dart';
import '../product_details/product_details_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final UserOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final liveOrder = context.watch<OrderProvider>().getOrderById(order.id) ?? order;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Order #${liveOrder.orderNumber}',
          style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // Order Status Header Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: liveOrder.status == OrderStatus.delivered
                  ? const LinearGradient(colors: [Color(0xFF2E6B4F), Color(0xFF1B4332)])
                  : AppColors.heroCardGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.champagneGold.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    liveOrder.status == OrderStatus.delivered
                        ? Icons.check_circle_outline
                        : Icons.local_shipping_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        liveOrder.status.displayName.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.champagneGoldLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        liveOrder.status == OrderStatus.delivered
                            ? 'Delivered on ${AppHelpers.formatDate(liveOrder.estimatedDelivery)}'
                            : 'Expected by ${AppHelpers.formatDate(liveOrder.estimatedDelivery)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Visual Tracking Timeline
          Text(
            'TRACKING TIMELINE',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              children: List.generate(liveOrder.trackingSteps.length, (index) {
                final step = liveOrder.trackingSteps[index];
                final isLast = index == liveOrder.trackingSteps.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step icon & vertical bar
                    Column(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: step.isCompleted
                                ? AppColors.champagneGold
                                : (isDark ? AppColors.secondaryCardDark : Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Icon(
                              step.isCompleted ? Icons.check : Icons.circle,
                              size: step.isCompleted ? 12 : 6,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 46,
                            color: step.isCompleted
                                ? AppColors.champagneGold.withValues(alpha: 0.5)
                                : (isDark ? Colors.white12 : Colors.black12),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Step Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: step.isCompleted
                                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                                  : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            step.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppHelpers.formatDateTime(step.time),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 24),

          // Items List
          Text(
            'ITEMS IN THIS SHIPMENT',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
            ),
          ),
          const SizedBox(height: 14),
          ...liveOrder.items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: item.product)),
                      );
                    },
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: LumoraImage(
                        imageUrl: item.product.images.isNotEmpty ? item.product.images.first : '',
                        borderRadius: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.selectedColor} • Qty: ${item.quantity}',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppHelpers.formatPrice(item.totalPrice),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),

          // Delivery Address & Payment Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  '${liveOrder.deliveryAddress.fullName}\n${liveOrder.deliveryAddress.formattedAddress}\nPhone: ${liveOrder.deliveryAddress.phone}',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const Divider(height: 24),
                const Text('Payment Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  liveOrder.paymentMethod,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount Paid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      AppHelpers.formatPrice(liveOrder.totalAmount),
                      style: AppTextStyles.priceRegular(isDark: isDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Cancel or Support
          if (liveOrder.status != OrderStatus.delivered && liveOrder.status != OrderStatus.cancelled)
            CustomButton(
              text: 'CANCEL ORDER',
              type: ButtonType.outline,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Cancel Order?'),
                    content: const Text('Are you sure you want to cancel this order? Any payments will be refunded to the source account within 24-48 hours.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Order')),
                      TextButton(
                        onPressed: () {
                          context.read<OrderProvider>().cancelOrder(liveOrder.id);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order has been cancelled.')),
                          );
                        },
                        child: const Text('Cancel Order', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
