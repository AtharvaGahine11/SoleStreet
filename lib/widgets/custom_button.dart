import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/app_text_styles.dart';

enum ButtonType { primary, secondary, gold, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 52,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onPressed == null || isLoading;

    Color getTextColor() {
      if (isDisabled) return isDark ? Colors.white38 : Colors.black26;
      switch (type) {
        case ButtonType.primary:
          return isDark ? Colors.black : Colors.white;
        case ButtonType.gold:
          return Colors.white;
        case ButtonType.secondary:
          return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
        case ButtonType.outline:
          return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
        case ButtonType.text:
          return AppColors.primaryRose;
      }
    }

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(getTextColor()),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 18, color: getTextColor()),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: AppTextStyles.button(
              color: getTextColor(),
              fontSize: 14.5,
            ),
          ),
        ],
      ],
    );

    if (type == ButtonType.gold) {
      return Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: isDisabled ? null : AppColors.luxuryGoldGradient,
          color: isDisabled ? (isDark ? Colors.grey.shade800 : Colors.grey.shade300) : null,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: AppColors.champagneGold.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Center(child: content),
          ),
        ),
      );
    }

    if (type == ButtonType.outline) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: content,
        ),
      );
    }

    if (type == ButtonType.text) {
      return TextButton(
        onPressed: isDisabled ? null : onPressed,
        child: content,
      );
    }

    // Default primary & secondary
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: type == ButtonType.primary
              ? (isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight)
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          foregroundColor: getTextColor(),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: content,
      ),
    );
  }
}
