import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../utils/helpers.dart';
import '../../providers/compare_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/lumora_image.dart';
import '../../widgets/custom_button.dart';
import '../product_details/product_details_screen.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compareProvider = context.watch<CompareProvider>();
    final items = compareProvider.compareList;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Compare Pieces (${items.length}/3)',
          style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => compareProvider.clearCompare(),
              child: const Text('Clear', style: TextStyle(color: AppColors.error)),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.compare_arrows_rounded,
                      size: 64,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No pieces in comparison',
                      style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the compare icon on any product page to view features, prices, and materials side-by-side.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium(isDark: isDark),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((prod) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Delete button
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => compareProvider.removeFromCompare(prod.id),
                              child: const Icon(Icons.close, size: 16),
                            ),
                          ),
                          // Image
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: prod)),
                              );
                            },
                            child: SizedBox(
                              height: 120,
                              width: double.infinity,
                              child: LumoraImage(
                                imageUrl: prod.images.isNotEmpty ? prod.images.first : '',
                                borderRadius: 10,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Title & Brand
                          Text(
                            prod.brand.toUpperCase(),
                            style: AppTextStyles.productBrand(fontSize: 9),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            prod.name,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Price
                          Text(
                            AppHelpers.formatPrice(prod.price),
                            style: AppTextStyles.priceRegular(isDark: isDark, fontSize: 15),
                          ),
                          const Divider(height: 16),

                          // Specs
                          _buildCompareField('RATING', '★ ${prod.rating} (${prod.reviewCount})', isDark),
                          _buildCompareField('MATERIAL', prod.material, isDark),
                          _buildCompareField('STYLE', prod.style, isDark),
                          _buildCompareField('GENDER', prod.gender.toUpperCase(), isDark),
                          const SizedBox(height: 12),

                          // Add to Bag Button
                          CustomButton(
                            text: '+ BAG',
                            type: ButtonType.gold,
                            height: 36,
                            onPressed: () {
                              context.read<CartProvider>().addToCart(prod);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added ${prod.name} to bag!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildCompareField(String title, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: AppColors.champagneGold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
