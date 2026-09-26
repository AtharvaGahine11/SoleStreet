import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/app_text_styles.dart';
import '../utils/helpers.dart';

class PriceWidget extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final bool isLarge;
  final bool showDiscountBadge;

  const PriceWidget({
    super.key,
    required this.price,
    this.originalPrice,
    this.isLarge = false,
    this.showDiscountBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasDiscount = originalPrice != null && originalPrice! > price;
    final discountPercent = hasDiscount
        ? AppHelpers.calculateDiscountPercent(originalPrice!, price)
        : 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          AppHelpers.formatPrice(price),
          style: isLarge
              ? AppTextStyles.priceLarge(isDark: isDark)
              : AppTextStyles.priceRegular(isDark: isDark),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 8),
          Text(
            AppHelpers.formatPrice(originalPrice!),
            style: AppTextStyles.originalPrice(
              isDark: isDark,
              fontSize: isLarge ? 15 : 12,
            ),
          ),
          if (showDiscountBadge && discountPercent > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryRose.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${discountPercent.toInt()}% OFF',
                style: AppTextStyles.discountBadge(fontSize: isLarge ? 11 : 9.5),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
