import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final double size;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryCardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            isEnabled: quantity > min,
            onTap: () {
              if (quantity > min) onChanged(quantity - 1);
            },
            isDark: isDark,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            isEnabled: quantity < max,
            onTap: () {
              if (quantity < max) onChanged(quantity + 1);
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: size,
        height: size,
        color: Colors.transparent,
        child: Icon(
          icon,
          size: 15,
          color: isEnabled
              ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
              : (isDark ? Colors.white24 : Colors.black26),
        ),
      ),
    );
  }
}
