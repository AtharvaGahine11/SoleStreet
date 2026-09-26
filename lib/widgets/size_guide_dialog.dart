import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/app_text_styles.dart';

class SizeGuideDialog extends StatelessWidget {
  final String category;

  const SizeGuideDialog({super.key, this.category = 'rings'});

  static void show(BuildContext context, {String category = 'rings'}) {
    showDialog(
      context: context,
      builder: (context) => SizeGuideDialog(category: category),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIZE GUIDE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Find Your Perfect Fit',
                      style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Size table
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.2),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1.5),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.secondaryCardDark : AppColors.secondaryCardLight,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                    ),
                    children: [
                      _buildHeaderCell('US Size', isDark),
                      _buildHeaderCell('Inside Dia (mm)', isDark),
                      _buildHeaderCell('Circumference', isDark),
                    ],
                  ),
                  _buildDataRow('US 6', '16.5 mm', '51.8 mm', isDark),
                  _buildDataRow('US 7', '17.3 mm', '54.4 mm', isDark),
                  _buildDataRow('US 8', '18.1 mm', '57.0 mm', isDark),
                  _buildDataRow('US 9', '18.9 mm', '59.5 mm', isDark),
                  _buildDataRow('US 10', '19.8 mm', '62.1 mm', isDark),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Helpful measurement tip
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryRose.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates_outlined, size: 18, color: AppColors.primaryRose),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: Wrap a strip of paper around your finger base, mark the overlap, and measure length in mm.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  TableRow _buildDataRow(String c1, String c2, String c3, bool isDark) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            c1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            c2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            c3,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
