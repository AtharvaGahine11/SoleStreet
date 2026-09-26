import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../services/product_service.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../product_details/product_details_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String title;
  final String? initialCategory;
  final String? initialGender;
  final String? initialStyle;

  const ProductListScreen({
    super.key,
    required this.title,
    this.initialCategory,
    this.initialGender,
    this.initialStyle,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductFilterOptions _currentFilters;

  @override
  void initState() {
    super.initState();
    _currentFilters = ProductFilterOptions(
      category: widget.initialCategory,
      gender: widget.initialGender,
      style: widget.initialStyle,
      sortBy: 'recommended',
    );
  }

  void _showSortOptions(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final sortOptions = [
          {'id': 'recommended', 'label': 'Recommended For You'},
          {'id': 'newest', 'label': 'Newest Additions'},
          {'id': 'price_low_high', 'label': 'Price: Low to High'},
          {'id': 'price_high_low', 'label': 'Price: High to Low'},
          {'id': 'rating', 'label': 'Highest Customer Rating'},
          {'id': 'popularity', 'label': 'Most Popular'},
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'SORT BY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                    ),
                  ),
                ),
                ...sortOptions.map((opt) {
                  final isSel = _currentFilters.sortBy == opt['id'];
                  return ListTile(
                    title: Text(
                      opt['label']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: isSel
                            ? (isDark ? AppColors.champagneGoldLight : AppColors.primaryRose)
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
                    trailing: isSel
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: isDark ? AppColors.champagneGoldLight : AppColors.primaryRose,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _currentFilters = _currentFilters.copyWith(sortBy: opt['id']);
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productService = ProductService();
    final products = productService.getProducts(filters: _currentFilters);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, size: 20),
            onPressed: () {
              FilterBottomSheet.show(
                context,
                initialOptions: _currentFilters,
                onApply: (newOptions) {
                  setState(() => _currentFilters = newOptions);
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Subheader: Product Count & Sort / Filter triggers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${products.length} Products',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                Row(
                  children: [
                    // Sort Button
                    GestureDetector(
                      onTap: () => _showSortOptions(context, isDark),
                      child: Row(
                        children: [
                          Icon(
                            Icons.sort_rounded,
                            size: 16,
                            color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Sort',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Filter Button
                    GestureDetector(
                      onTap: () {
                        FilterBottomSheet.show(
                          context,
                          initialOptions: _currentFilters,
                          onApply: (newOptions) {
                            setState(() => _currentFilters = newOptions);
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list_rounded,
                            size: 16,
                            color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Product Grid or Empty State
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No items match your filter',
                            style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try expanding your price range or clearing some filter options.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium(isDark: isDark),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _currentFilters = const ProductFilterOptions(sortBy: 'recommended');
                              });
                            },
                            child: const Text(
                              'Reset All Filters',
                              style: TextStyle(
                                color: AppColors.champagneGold,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final prod = products[index];
                      return ProductCard(
                        product: prod,
                        onTap: () {
                          context.read<ProductProvider>().addToRecentlyViewed(prod);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(product: prod),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
