import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../models/order.dart';
import '../../utils/helpers.dart';
import '../../providers/order_provider.dart';
import '../../widgets/lumora_image.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No orders yet',
                      style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When you place orders with HEERA, your tracking timeline and receipts will appear here.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium(isDark: isDark),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(context, order, isDark);
              },
            ),
    );
  }

  Widget _buildOrderCard(BuildContext context, UserOrder order, bool isDark) {
    final isDelivered = order.status == OrderStatus.delivered;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(order: order),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderNumber}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppHelpers.formatDate(order.createdAt),
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDelivered
                        ? AppColors.success.withValues(alpha: 0.12)
                        : AppColors.champagneGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDelivered ? AppColors.success : AppColors.champagneGold,
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    order.status.displayName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDelivered ? AppColors.success : AppColors.champagneGold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Item Previews Thumbnail Row
            Row(
              children: [
                ...order.items.take(3).map((item) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 52,
                    height: 52,
                    child: LumoraImage(
                      imageUrl: item.product.images.isNotEmpty ? item.product.images.first : '',
                      borderRadius: 10,
                    ),
                  );
                }),
                if (order.items.length > 3)
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.secondaryCardDark : AppColors.secondaryCardLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '+${order.items.length - 3}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${order.items.length} ${order.items.length == 1 ? 'Item' : 'Items'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppHelpers.formatPrice(order.totalAmount),
                      style: AppTextStyles.priceRegular(isDark: isDark),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Est. Delivery: ${AppHelpers.formatDate(order.estimatedDelivery)}',
                  style: const TextStyle(fontSize: 11.5, color: AppColors.champagneGold, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
