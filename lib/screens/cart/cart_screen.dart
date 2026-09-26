import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../utils/helpers.dart';
import '../../utils/constants.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/lumora_image.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/quantity_selector.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/coupon_bottom_sheet.dart';
import '../checkout/checkout_screen.dart';
import '../product_details/product_details_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;
    final savedForLater = cartProvider.savedForLater;

    if (cartProvider.isEmpty && savedForLater.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            'My Bag',
            style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.champagneGold.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 38,
                      color: AppColors.champagneGold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your bag is waiting ✨',
                  style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'Looks like you haven\'t added any fine jewellery pieces to your bag yet.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(isDark: isDark),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'START SHOPPING',
                  type: ButtonType.gold,
                  width: 220,
                  onPressed: () {
                    // Navigate to home or explore
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'My Bag (${cartProvider.itemCount})',
          style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
        ),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, size: 22),
              tooltip: 'Clear Bag',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Shopping Bag?'),
                    content: const Text('Are you sure you want to remove all items from your bag?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartProvider.clearCart();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Clear', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 160),
            children: [
              // Free delivery progress banner
              if (cartProvider.subtotal < AppConstants.freeDeliveryThreshold)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.champagneGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, color: AppColors.champagneGold, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Add ${AppHelpers.formatPrice(AppConstants.freeDeliveryThreshold - cartProvider.subtotal)} more for COMPLIMENTARY EXPRESS DELIVERY',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Cart Items List
              ...items.map((item) => _buildCartItemCard(context, item, isDark)),
              const SizedBox(height: 16),

              // Coupon Trigger Card
              GestureDetector(
                onTap: () => CouponBottomSheet.show(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: cartProvider.appliedCoupon != null
                          ? AppColors.champagneGold
                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: cartProvider.appliedCoupon != null ? 1.2 : 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.champagneGold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.discount_outlined,
                          color: AppColors.champagneGold,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartProvider.appliedCoupon != null
                                  ? 'Coupon Applied: ${cartProvider.appliedCoupon!.code}'
                                  : 'Apply Promo Coupon',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cartProvider.appliedCoupon != null
                                  ? 'You saved ${AppHelpers.formatPrice(cartProvider.couponDiscount)} on this order'
                                  : 'Select from available atelier offers & save up to 25%',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: cartProvider.appliedCoupon != null
                                    ? AppColors.success
                                    : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Price Breakdown Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDER SUMMARY',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildSummaryRow(
                      'Bag Subtotal',
                      AppHelpers.formatPrice(cartProvider.subtotal),
                      isDark: isDark,
                    ),
                    if (cartProvider.productSavings > 0) ...[
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        'Retail Discount',
                        '- ${AppHelpers.formatPrice(cartProvider.productSavings)}',
                        isDark: isDark,
                        valueColor: AppColors.success,
                      ),
                    ],
                    if (cartProvider.couponDiscount > 0) ...[
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        'Coupon (${cartProvider.appliedCoupon?.code})',
                        '- ${AppHelpers.formatPrice(cartProvider.couponDiscount)}',
                        isDark: isDark,
                        valueColor: AppColors.success,
                      ),
                    ],
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Delivery Fee',
                      cartProvider.deliveryFee == 0
                          ? 'FREE'
                          : AppHelpers.formatPrice(cartProvider.deliveryFee),
                      isDark: isDark,
                      valueColor: cartProvider.deliveryFee == 0 ? AppColors.success : null,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated Total',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          AppHelpers.formatPrice(cartProvider.totalAmount),
                          style: AppTextStyles.priceLarge(isDark: isDark, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Saved For Later Section
              if (savedForLater.isNotEmpty) ...[
                Text(
                  'SAVED FOR LATER (${savedForLater.length})',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                  ),
                ),
                const SizedBox(height: 12),
                ...savedForLater.map((prod) => _buildSavedForLaterCard(context, prod, isDark)),
              ],
            ],
          ),

          // Bottom Checkout Bar
          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1C1A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Payable',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                      ),
                      Text(
                        AppHelpers.formatPrice(cartProvider.totalAmount),
                        style: AppTextStyles.priceLarge(isDark: isDark, fontSize: 19),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CustomButton(
                    text: 'CHECKOUT →',
                    type: ButtonType.gold,
                    width: 150,
                    height: 46,
                    borderRadius: 14,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item, bool isDark) {
    final cartProvider = context.read<CartProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: item.product)),
              );
            },
            child: SizedBox(
              width: 85,
              height: 95,
              child: LumoraImage(
                imageUrl: item.product.images.isNotEmpty ? item.product.images.first : '',
                borderRadius: 12,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.product.brand.toUpperCase(),
                      style: AppTextStyles.productBrand(fontSize: 10),
                    ),
                    GestureDetector(
                      onTap: () {
                        cartProvider.removeFromCart(
                          item.product.id,
                          color: item.selectedColor,
                          size: item.selectedSize,
                        );
                      },
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.selectedColor} • ${item.selectedSize}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 10),

                // Price and Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceWidget(
                      price: item.totalPrice,
                      originalPrice: item.totalOriginalPrice,
                      showDiscountBadge: false,
                    ),
                    QuantitySelector(
                      quantity: item.quantity,
                      size: 28,
                      onChanged: (q) {
                        cartProvider.updateQuantity(
                          item.product.id,
                          q,
                          color: item.selectedColor,
                          size: item.selectedSize,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => cartProvider.saveForLater(item),
                    child: Text(
                      'Save for later',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.champagneGoldLight : AppColors.primaryRose,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedForLaterCard(BuildContext context, Product product, bool isDark) {
    final cartProvider = context.read<CartProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: LumoraImage(
              imageUrl: product.images.isNotEmpty ? product.images.first : '',
              borderRadius: 10,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
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
                  AppHelpers.formatPrice(product.price),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => cartProvider.moveToCart(product),
            child: const Text(
              'MOVE TO BAG',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.champagneGold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    String value, {
    required bool isDark,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}
