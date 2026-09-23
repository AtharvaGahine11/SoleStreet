import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../theme/app_theme.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: AppTheme.cardDecoration(isDark, borderRadius: AppTheme.radiusLG),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shoe Image Container
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            child: Container(
              width: 88,
              height: 88,
              color: AppTheme.imageContainerColor(isDark),
              padding: const EdgeInsets.all(AppTheme.spaceSM),
              child: Image.network(
                item.product.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.sports_basketball_rounded,
                  color: isDark ? Colors.white24 : Colors.black26,
                  size: 32,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spaceMD),

          // Details & Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Name
                Text(
                  item.product.brand.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(height: 2),

                // Product Name
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                // Size & Color Pills Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.darkBackground
                            : AppTheme.lightImageContainer,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      ),
                      child: Text(
                        'Size: ${item.selectedSize}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.darkBackground
                            : AppTheme.lightImageContainer,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      ),
                      child: Text(
                        item.selectedColor,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Price and Quantity Stepper + Delete Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${item.totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                        color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                      ),
                    ),

                    Row(
                      children: [
                        // Quantity Stepper Container
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkBackground : AppTheme.lightImageContainer,
                            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                            border: Border.all(
                              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: onDecrement,
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppTheme.radiusSM)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Icon(
                                    Icons.remove_rounded,
                                    size: 15,
                                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  '${item.quantity}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: onIncrement,
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(AppTheme.radiusSM)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Icon(
                                    Icons.add_rounded,
                                    size: 15,
                                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Delete Trash Button
                        GestureDetector(
                          onTap: onRemove,
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

