import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/filter_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToShop;

  const HomeScreen({
    Key? key,
    required this.onNavigateToShop,
  }) : super(key: key);

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final gridColumns = AppTheme.getGridColumnCount(screenWidth);

    final trendingProducts = appState.allProducts.where((p) => p.isBestSeller).toList();
    final newArrivals = appState.allProducts.where((p) => p.isNew).toList();
    final bestSellers = appState.allProducts.take(6).toList();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Greeting Header
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spaceXL,
                    AppTheme.spaceLG,
                    AppTheme.spaceXL,
                    AppTheme.spaceMD,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Good morning, Atharva',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('👋', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Find your perfect pair.',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            appState.toggleThemeMode();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                              border: Border.all(
                                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                              ),
                            ),
                            child: Icon(
                              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                              size: 20,
                              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
                  sliver: SliverToBoxAdapter(
                    child: SearchBarWidget(
                      query: appState.searchQuery,
                      onChanged: (query) {
                        appState.setSearchQuery(query);
                        if (query.isNotEmpty) {
                          onNavigateToShop();
                        }
                      },
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
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spaceLG)),

                // Categories Chips (Horizontally Scrollable)
                SliverPadding(
                  padding: const EdgeInsets.only(left: AppTheme.spaceXL),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = appState.selectedCategory == category;
                          return CategoryChip(
                            category: category,
                            isSelected: isSelected,
                            onTap: () {
                              appState.setSelectedCategory(category);
                              onNavigateToShop();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spaceXL)),

                // Hero Banner
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
                  sliver: SliverToBoxAdapter(
                    child: PromotionalBanner(
                      onShopNowTap: onNavigateToShop,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spaceSection)),

                // Trending Now Header
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
                  sliver: SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      'Trending Now',
                      onNavigateToShop,
                      isDark,
                    ),
                  ),
                ),

                // Horizontal Trending Carousel
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: AppTheme.spaceXL,
                    top: AppTheme.spaceMD,
                    bottom: AppTheme.spaceSection,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 290,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: trendingProducts.length,
                        itemBuilder: (context, index) {
                          final product = trendingProducts[index];
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: AppTheme.spaceMD),
                            child: ProductCard(product: product),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // New Arrivals Header
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
                  sliver: SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      'New Arrivals',
                      onNavigateToShop,
                      isDark,
                    ),
                  ),
                ),

                // Grid for New Arrivals
                SliverPadding(
                  padding: const EdgeInsets.all(AppTheme.spaceXL),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: AppTheme.spaceMD,
                      mainAxisSpacing: AppTheme.spaceMD,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = newArrivals[index % newArrivals.length];
                        return ProductCard(product: product);
                      },
                      childCount: newArrivals.length > 6 ? 6 : newArrivals.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spaceLG)),

                // Best Sellers Header
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
                  sliver: SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      'Best Sellers',
                      onNavigateToShop,
                      isDark,
                    ),
                  ),
                ),

                // Grid for Best Sellers
                SliverPadding(
                  padding: const EdgeInsets.all(AppTheme.spaceXL),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: AppTheme.spaceMD,
                      mainAxisSpacing: AppTheme.spaceMD,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = bestSellers[index];
                        return ProductCard(product: product);
                      },
                      childCount: bestSellers.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spaceSection)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Row(
            children: [
              Text(
                'See All',
                style: TextStyle(
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

