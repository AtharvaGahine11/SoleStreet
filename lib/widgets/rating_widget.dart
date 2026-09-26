import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/app_text_styles.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double iconSize;
  final bool showNumber;

  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewCount,
    this.iconSize = 13,
    this.showNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star_rounded,
          size: iconSize,
          color: AppColors.starFilled,
        ),
        if (showNumber) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: iconSize * 0.95,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: AppTextStyles.bodySmall(
              isDark: isDark,
              fontSize: iconSize * 0.85,
            ),
          ),
        ],
      ],
    );
  }
}
