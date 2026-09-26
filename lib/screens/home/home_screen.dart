import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/dummy_products.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/lumora_logo.dart';
import '../../widgets/lumora_image.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';
import '../search/search_screen.dart';
import '../notifications/notifications_screen.dart';
import '../products/product_list_screen.dart';
import '../product_details/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  final List<_HeroBannerData> _heroBanners = [
    _HeroBannerData(
      tag: 'NEW SEASON DROP',
      title: 'DEFINE YOUR\nSIGNATURE STYLE',
      subtitle: 'Up to 40% OFF on 18K Gold Vermeil & Pearls',
      buttonText: 'SHOP COLLECTION',
      imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=1000&q=80',
      category: 'necklaces',
    ),
    _HeroBannerData(
      tag: 'FINE JEWELLERY',
      title: 'ETERNAL\nBRILLIANCE',
      subtitle: 'VVS Moissanite & 18K Solid Gold Bands',
      buttonText: 'EXPLORE RINGS',
      imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?auto=format&fit=crop&w=1000&q=80',
      category: 'rings',
    ),
    _HeroBannerData(
      tag: 'TIMEPIECE EDIT',
      title: 'OBSIDIAN\nAUTOMATICS',
      subtitle: 'Precision Japanese movement & sapphire crystal',
      buttonText: 'EXPLORE WATCHES',
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1000&q=80',
      category: 'watches',
    ),
    _HeroBannerData(
      tag: 'BESPOKE LEATHER',
      title: 'ITALIAN CALFSKIN\nACCENTS',
      subtitle: 'Structured crossbodies & handcrafted duffels',
      buttonText: 'DISCOVER BAGS',
      imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=1000&q=80',
      category: 'bags',
    ),
    _HeroBannerData(
      tag: 'OPTICS & SHADES',
      title: 'ARCHITECTURAL\nEYEWEAR',
      subtitle: 'UV400 Polarized Italian Bio-Acetate frames',
      buttonText: 'SHOP EYEWEAR',
      imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=1000&q=80',
      category: 'sunglasses',
    ),
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productProvider = context.watch<ProductProvider>();
    final authProvider = context.watch<AuthProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final unreadCount = notificationProvider.unreadCount;
    final userName = authProvider.currentUser?.name.split(' ').first ?? 'Atharva';

    final trending = productProvider.trendingProducts;
    final newArrivals = productProvider.newArrivals;
    final pickedForYou = productProvider.pickedForYou;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const LumoraLogo(fontSize: 24),
                    Row(
                      children: [
                        // Search quick icon
                        IconButton(
                          icon: const Icon(Icons.search_rounded, size: 24),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SearchScreen()),
                            );
                          },
                        ),
                        // Notifications
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_none_rounded, size: 24),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                                );
                              },
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryRose,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Greeting & Search Input Trigger
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Good Morning, $userName',
                          style: AppTextStyles.heroHeading(
                            isDark: isDark,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('✨', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'What are you looking for today?',
                      style: AppTextStyles.bodyMedium(isDark: isDark),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar Box (Tapping opens search)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Search jewellery, watches & more...',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.tune_rounded,
                                size: 16,
                                color: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Gender Segment Tabs (Women, Men, Unisex, All)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildGenderChip('All Collections', 'all', productProvider, isDark),
                    const SizedBox(width: 8),
                    _buildGenderChip("Women's", 'women', productProvider, isDark),
                    const SizedBox(width: 8),
                    _buildGenderChip("Men's", 'men', productProvider, isDark),
                    const SizedBox(width: 8),
                    _buildGenderChip('Unisex', 'unisex', productProvider, isDark),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Hero Banner Carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 210,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _bannerController,
                      itemCount: _heroBanners.length,
                      onPageChanged: (i) => setState(() => _currentBannerIndex = i),
                      itemBuilder: (context, index) {
                        final banner = _heroBanners[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductListScreen(
                                    title: banner.title.replaceAll('\n', ' '),
                                    initialCategory: banner.category,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    LumoraImage(
                                      imageUrl: banner.imageUrl,
                                      borderRadius: 20,
                                    ),
                                    // Gradient overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: const [0.0, 0.65, 1.0],
                                          colors: [
                                            Colors.black.withValues(alpha: 0.85),
                                            Colors.black.withValues(alpha: 0.5),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Content
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.champagneGold,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              banner.tag,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            banner.title,
                                            style: AppTextStyles.heroHeading(isDark: true, fontSize: 20).copyWith(
                                              color: Colors.white,
                                              height: 1.15,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            banner.subtitle,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                banner.buttonText,
                                                style: const TextStyle(
                                                  color: AppColors.champagneGoldLight,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                size: 14,
                                                color: AppColors.champagneGoldLight,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Banner Indicators
                    Positioned(
                      bottom: 12,
                      right: 36,
                      child: Row(
                        children: List.generate(_heroBanners.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(left: 4),
                            width: _currentBannerIndex == i ? 16 : 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: _currentBannerIndex == i ? AppColors.champagneGold : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Quick Category Section
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Categories',
                subtitle: 'Curated Collections',
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProductListScreen(title: 'All Jewellery & Accessories'),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 105,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: DummyData.categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final cat = DummyData.categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductListScreen(
                              title: cat.name,
                              initialCategory: cat.id == 'all' ? null : cat.id,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardDark : AppColors.cardLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: cat.imageUrl != null
                                  ? LumoraImage(imageUrl: cat.imageUrl!, fit: BoxFit.cover)
                                  : Center(child: Text(cat.icon, style: const TextStyle(fontSize: 24))),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 72,
                            child: Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            // Shop by Style
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Shop by Style',
                subtitle: 'Curated Aesthetic Moods',
                actionText: 'See All',
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProductListScreen(title: 'Shop By Style'),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: DummyData.styleCards.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final style = DummyData.styleCards[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductListScreen(
                              title: '${style.name} Collection',
                              initialStyle: style.name,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 165,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            width: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              LumoraImage(imageUrl: style.imageUrl, fit: BoxFit.cover),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.1),
                                      Colors.black.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      style.name.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      style.tagline,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.85),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
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
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Trending Now ✨ Carousel
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Trending Now ✨',
                subtitle: 'Most Coveted Pieces',
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProductListScreen(title: 'Trending Now'),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 275,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: trending.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final prod = trending[index];
                    return ProductCard(
                      product: prod,
                      width: 180,
                      onTap: () {
                        productProvider.addToRecentlyViewed(prod);
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
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Promo Banner: Luxury Craftsmanship
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroCardGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ATELIER GUARANTEE',
                              style: TextStyle(
                                color: AppColors.champagneGold,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Anti-Tarnish & Sweatproof',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Engineered with 316L titanium steel & 18K vacuum plating.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11.5,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.champagneGold.withValues(alpha: 0.2),
                          border: Border.all(color: AppColors.champagneGold),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.shield_outlined,
                            color: AppColors.champagneGoldLight,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Fresh Drops (New Arrivals) 2-Column Grid
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Fresh Drops',
                subtitle: 'Just Arrived',
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProductListScreen(title: 'Fresh Drops'),
                    ),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final prod = newArrivals[index];
                    return ProductCard(
                      product: prod,
                      onTap: () {
                        productProvider.addToRecentlyViewed(prod);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsScreen(product: prod),
                          ),
                        );
                      },
                    );
                  },
                  childCount: newArrivals.length.clamp(0, 4),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Picked For You (Personalized Mock Recommendation Engine)
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Picked For You ✨',
                subtitle: 'Based on your aesthetic taste',
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProductListScreen(title: 'Curated For You'),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 275,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: pickedForYou.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final prod = pickedForYou[index];
                    return ProductCard(
                      product: prod,
                      width: 180,
                      onTap: () {
                        productProvider.addToRecentlyViewed(prod);
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
            ),

            // Extra padding at bottom for floating bottom navigation bar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderChip(
    String label,
    String genderVal,
    ProductProvider provider,
    bool isDark,
  ) {
    final isSel = provider.selectedGender == genderVal;
    return GestureDetector(
      onTap: () => provider.setSelectedGender(genderVal),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSel
              ? (isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight)
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSel
                ? Colors.transparent
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
              color: isSel
                  ? (isDark ? Colors.black : Colors.white)
                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBannerData {
  final String tag;
  final String title;
  final String subtitle;
  final String buttonText;
  final String imageUrl;
  final String category;

  _HeroBannerData({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageUrl,
    required this.category,
  });
}
