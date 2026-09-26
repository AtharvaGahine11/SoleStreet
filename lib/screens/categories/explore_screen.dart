import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/dummy_products.dart';
import '../../providers/product_provider.dart';
import '../../widgets/lumora_image.dart';
import '../../widgets/custom_search_bar.dart';
import '../search/search_screen.dart';
import '../products/product_list_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _genderTabs = ['All', "Women", "Men", 'Unisex'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _genderTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Collections',
                        style: AppTextStyles.heroHeading(isDark: isDark, fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Discover handcrafted jewellery, timepieces & accessories.',
                        style: AppTextStyles.bodyMedium(isDark: isDark),
                      ),
                      const SizedBox(height: 16),
                      CustomSearchBar(
                        readOnly: true,
                        showFilterButton: false,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SearchScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    indicatorColor: isDark ? AppColors.champagneGoldLight : AppColors.primaryRose,
                    indicatorWeight: 2.5,
                    labelColor: isDark ? AppColors.champagneGoldLight : AppColors.primaryRose,
                    unselectedLabelColor: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                    labelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                    tabs: _genderTabs.map((tab) => Tab(text: tab)).toList(),
                  ),
                  isDark: isDark,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildCategoryGrid(null, isDark, productProvider),
              _buildCategoryGrid('women', isDark, productProvider),
              _buildCategoryGrid('men', isDark, productProvider),
              _buildCategoryGrid('unisex', isDark, productProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(
    String? gender,
    bool isDark,
    ProductProvider productProvider,
  ) {
    final categories = DummyData.categories.where((c) {
      if (c.id == 'all') return false;
      if (gender == null) return true;
      return c.gender == 'all' || c.gender == gender;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.9,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final count = DummyData.products
                .where((p) =>
                    p.category == category.id &&
                    (gender == null || p.gender == gender || p.gender == 'unisex'))
                .length;

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductListScreen(
                      title: category.name,
                      initialCategory: category.id,
                      initialGender: gender,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      if (category.imageUrl != null)
                        LumoraImage(imageUrl: category.imageUrl!, fit: BoxFit.cover)
                      else
                        Container(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          child: Center(
                            child: Text(category.icon, style: const TextStyle(fontSize: 40)),
                          ),
                        ),

                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.3, 1.0],
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),

                      // Text info at bottom
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$count Pieces Available',
                              style: const TextStyle(
                                color: AppColors.champagneGoldLight,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  _SliverTabBarDelegate(this.tabBar, {required this.isDark});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || isDark != oldDelegate.isDark;
  }
}
