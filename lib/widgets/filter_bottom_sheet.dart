import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _tempCategory;
  late String? _tempPriceRange;
  late double _tempMinRating;
  late String _tempSortBy;

  final List<String> categories = [
    'All',
    'Sneakers',
    'Running',
    'Basketball',
    'Lifestyle',
    'Streetwear',
    'Accessories',
  ];

  final List<String> priceRanges = [
    'Under ₹2,000',
    '₹2,000–₹5,000',
    '₹5,000–₹10,000',
    'Above ₹10,000',
  ];

  final List<String> sortOptions = [
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Newest',
  ];

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _tempCategory = appState.selectedCategory;
    _tempPriceRange = appState.selectedPriceRange;
    _tempMinRating = appState.selectedMinRating;
    _tempSortBy = appState.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters & Sorting ⚙️',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempCategory = 'All';
                      _tempPriceRange = null;
                      _tempMinRating = 0.0;
                      _tempSortBy = 'Popular';
                    });
                  },
                  child: const Text(
                    'Reset All',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
            Divider(height: 20, color: isDark ? Colors.white10 : Colors.black12),

            // 1. Sort By Section
            const SizedBox(height: 10),
            Text(
              'Sort By',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sortOptions.map((option) {
                final isSelected = _tempSortBy == option;
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextPrimary),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _tempSortBy = option);
                  },
                );
              }).toList(),
            ),

            // 2. Category Section
            const SizedBox(height: 20),
            Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final isSelected = _tempCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextPrimary),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _tempCategory = cat);
                  },
                );
              }).toList(),
            ),

            // 3. Price Range Section
            const SizedBox(height: 20),
            Text(
              'Price Range',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: priceRanges.map((range) {
                final isSelected = _tempPriceRange == range;
                return ChoiceChip(
                  label: Text(range),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextPrimary),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _tempPriceRange = selected ? range : null;
                    });
                  },
                );
              }).toList(),
            ),

            // 4. Rating Filter
            const SizedBox(height: 20),
            Text(
              'Minimum Rating',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildRatingChip(0.0, 'All Stars', isDark),
                const SizedBox(width: 8),
                _buildRatingChip(3.0, '3★ & above', isDark),
                const SizedBox(width: 8),
                _buildRatingChip(4.0, '4★ & above', isDark),
              ],
            ),

            // Apply Button
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  appState.setSelectedCategory(_tempCategory);
                  appState.setPriceRange(_tempPriceRange);
                  appState.setMinRating(_tempMinRating);
                  appState.setSortBy(_tempSortBy);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: AppTheme.primaryColor.withValues(alpha: 0.4),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingChip(double rating, String label, bool isDark) {
    final isSelected = _tempMinRating == rating;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primaryColor,
      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextPrimary),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 12,
      ),
      onSelected: (selected) {
        if (selected) setState(() => _tempMinRating = rating);
      },
    );
  }
}

