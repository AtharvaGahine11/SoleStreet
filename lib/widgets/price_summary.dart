import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PriceSummaryCard extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double delivery;
  final double total;
  final String? appliedCoupon;
  final VoidCallback? onRemoveCoupon;

  const PriceSummaryCard({
    Key? key,
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.total,
    this.appliedCoupon,
    this.onRemoveCoupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceXL),
      decoration: AppTheme.cardDecoration(isDark, borderRadius: AppTheme.radiusXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
              ),
              if (discount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.emeraldGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Text(
                    'Saving ₹${discount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppTheme.emeraldGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLG),

          _buildRow('Subtotal', '₹${subtotal.toStringAsFixed(0)}', isDark),
          const SizedBox(height: AppTheme.spaceSM),

          if (discount > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Coupon Discount',
                      style: TextStyle(color: AppTheme.emeraldGreen, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    if (appliedCoupon != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          appliedCoupon!,
                          style: const TextStyle(
                            color: AppTheme.emeraldGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (onRemoveCoupon != null)
                        GestureDetector(
                          onTap: onRemoveCoupon,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(Icons.close, size: 14, color: Colors.red),
                          ),
                        ),
                    ],
                  ],
                ),
                Text(
                  '-₹${discount.toStringAsFixed(0)}',
                  style: const TextStyle(color: AppTheme.emeraldGreen, fontSize: 13, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceSM),
          ],

          _buildRow(
            'Delivery',
            delivery == 0 ? 'FREE' : '₹${delivery.toStringAsFixed(0)}',
            isDark,
            isFree: delivery == 0,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceMD),
            child: Divider(
              height: 1,
              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, bool isDark, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            fontSize: 13.5,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isFree
                ? AppTheme.emeraldGreen
                : (isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }
}

