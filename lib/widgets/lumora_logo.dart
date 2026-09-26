import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/app_text_styles.dart';

class LumoraLogo extends StatelessWidget {
  final double fontSize;
  final bool showSubtitle;
  final Color? color;
  final bool isDark;

  const LumoraLogo({
    super.key,
    this.fontSize = 24,
    this.showSubtitle = false,
    this.color,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = isDark || theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Minimal Geometric Heritage Spark Mark
            Container(
              width: fontSize * 0.75,
              height: fontSize * 0.75,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.luxuryGoldGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.champagneGold.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  size: fontSize * 0.45,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'HEERA',
              style: AppTextStyles.brandLogo(
                isDark: isDarkMode,
                fontSize: fontSize,
              ).copyWith(
                letterSpacing: 3.5,
                color: color ?? (isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
            ),
          ],
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 4),
          Text(
            'WHERE HERITAGE MEETS ELEGANCE',
            style: TextStyle(
              fontSize: fontSize * 0.28,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.4,
              color: isDarkMode ? AppColors.champagneGoldLight : AppColors.champagneGold,
            ),
          ),
        ],
      ],
    );
  }
}
