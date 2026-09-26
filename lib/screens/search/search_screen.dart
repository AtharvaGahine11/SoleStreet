import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/product_card.dart';
import '../product_details/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  final List<String> _popularSearches = [
    'Minimal Gold Chain',
    'Pearl Earrings',
    'Obsidian Watch',
    'Cuban Link Chain',
    'Solitaire Ring',
    'Crossbody Bag',
    'Polarized Sunglasses',
    'Leather Wallet',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductProvider>().search(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _executeSearch(String query) {
    _searchController.text = query;
    context.read<ProductProvider>().submitSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productProvider = context.watch<ProductProvider>();
    final results = productProvider.searchResults;
    final recentSearches = productProvider.recentSearches;
    final hasQuery = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            productProvider.search('');
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CustomSearchBar(
            controller: _searchController,
            autofocus: widget.initialQuery == null,
            showFilterButton: false,
            onChanged: (query) {
              productProvider.search(query);
            },
            onSubmitted: (query) {
              _executeSearch(query);
            },
          ),
        ),
      ),
      body: hasQuery
          ? (results.isEmpty
              ? _buildNoResultsState(isDark)
              : _buildResultsGrid(results, isDark))
          : _buildSuggestionsView(recentSearches, isDark),
    );
  }

  Widget _buildSuggestionsView(List<String> recentSearches, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Recent Searches Header
        if (recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT SEARCHES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<ProductProvider>().clearRecentSearches();
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryRose),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentSearches.map((term) {
              return ActionChip(
                backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                side: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                avatar: Icon(
                  Icons.history_rounded,
                  size: 14,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                ),
                label: Text(
                  term,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                onPressed: () => _executeSearch(term),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
        ],

        // Popular Searches
        Text(
          'POPULAR SEARCHES',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularSearches.map((term) {
            return ActionChip(
              backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              avatar: const Icon(
                Icons.trending_up_rounded,
                size: 14,
                color: AppColors.champagneGold,
              ),
              label: Text(
                term,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              onPressed: () => _executeSearch(term),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResultsGrid(List<Product> results, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
          child: Text(
            'Found ${results.length} pieces',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final prod = results[index];
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
    );
  }

  Widget _buildNoResultsState(bool isDark) {
    return Center(
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
              'We couldn\'t find that',
              style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Try checking your spelling or exploring our curated categories.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(isDark: isDark),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                context.read<ProductProvider>().search('');
              },
              child: const Text('View All Jewellery'),
            ),
          ],
        ),
      ),
    );
  }
}
