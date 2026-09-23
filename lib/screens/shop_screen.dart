import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/empty_state_widget.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  final List<String> categories = const [
    'All',
    'Sneakers',
    'Running',
    'Basketball',
    'Lifestyle',
    'Streetwear',
    'Accessories',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final filteredProducts = appState.filteredProducts;
    final screenWidth = MediaQuery.of(context).size.width;
    final gridColumns = AppTheme.getGridColumnCount(screenWidth);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spaceXL,
                    AppTheme.spaceLG,
                    AppTheme.spaceXL,
                    AppTheme.spaceMD,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sneakers',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Text(
                        '${filteredProducts.length} items',
                        style: TextStyle(
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
                  child: SearchBarWidget(
                    query: appState.searchQuery,
                    onChanged: (query) => appState.setSearchQuery(query),
                    onFilterTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const FilterBottomSheet(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppTheme.spaceMD),

                // Categories Row
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: AppTheme.spaceXL),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = appState.selectedCategory == category;
                      return CategoryChip(
                        category: category,
                        isSelected: isSelected,
                        onTap: () => appState.setSelectedCategory(category),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppTheme.spaceSM),

                // Active Filters Row
                if (appState.searchQuery.isNotEmpty ||
                    appState.selectedCategory != 'All' ||
                    appState.selectedPriceRange != null ||
                    appState.selectedMinRating > 0 ||
                    appState.sortBy != 'Popular')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (appState.searchQuery.isNotEmpty)
                                  _buildActiveFilterChip('Search: ${appState.searchQuery}', isDark),
                                if (appState.selectedCategory != 'All')
                                  _buildActiveFilterChip('Category: ${appState.selectedCategory}', isDark),
                                if (appState.selectedPriceRange != null)
                                  _buildActiveFilterChip('Price: ${appState.selectedPriceRange}', isDark),
                                if (appState.sortBy != 'Popular')
                                  _buildActiveFilterChip('Sort: ${appState.sortBy}', isDark),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => appState.clearFilters(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Product Grid or Empty State
                Expanded(
                  child: filteredProducts.isEmpty
                      ? EmptyStateWidget(
                          icon: Icons.search_off_rounded,
                          title: 'No sneakers found',
                          message: 'We couldn\'t find any sneakers matching your search or filters.',
                          buttonText: 'Clear Filters',
                          onButtonPressed: () => appState.clearFilters(),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(AppTheme.spaceXL),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridColumns,
                            childAspectRatio: 0.62,
                            crossAxisSpacing: AppTheme.spaceMD,
                            mainAxisSpacing: AppTheme.spaceMD,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return ProductCard(product: product);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightImageContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
        ),
      ),
    );
  }
}

