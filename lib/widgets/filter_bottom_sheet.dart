import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/app_text_styles.dart';
import 'custom_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final ProductFilterOptions initialOptions;
  final ValueChanged<ProductFilterOptions> onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialOptions,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required ProductFilterOptions initialOptions,
    required ValueChanged<ProductFilterOptions> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        initialOptions: initialOptions,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _selectedGender;
  late String? _selectedCategory;
  late String? _selectedStyle;
  late RangeValues _priceRange;
  late String? _selectedMaterial;
  late String? _selectedColor;
  late double? _minRating;

  final List<String> _genders = ['All', 'Women', 'Men', 'Unisex'];
  final List<String> _categories = [
    'All',
    'Necklaces',
    'Earrings',
    'Rings',
    'Bracelets',
    'Watches',
    'Bags',
    'Sunglasses',
    'Accessories',
    'Anklets',
  ];
  final List<String> _materials = [
    'All',
    'Gold',
    'Silver',
    'Stainless Steel',
    'Leather',
    'Pearl',
    'Titanium',
  ];
  final List<String> _colors = [
    'All',
    'Gold',
    'Silver',
    'Black',
    'Rose Gold',
    'Pearl',
    'Cognac',
  ];

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialOptions.gender != null
        ? _capitalize(widget.initialOptions.gender!)
        : 'All';
    _selectedCategory = widget.initialOptions.category != null
        ? _capitalize(widget.initialOptions.category!)
        : 'All';
    _selectedStyle = widget.initialOptions.style ?? 'All';
    _priceRange = RangeValues(
      widget.initialOptions.minPrice ?? 500,
      widget.initialOptions.maxPrice ?? 8000,
    );
    _selectedMaterial = widget.initialOptions.material ?? 'All';
    _selectedColor = widget.initialOptions.color ?? 'All';
    _minRating = widget.initialOptions.minRating;
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle Bar & Header
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedGender = 'All';
                      _selectedCategory = 'All';
                      _selectedStyle = 'All';
                      _priceRange = const RangeValues(500, 8000);
                      _selectedMaterial = 'All';
                      _selectedColor = 'All';
                      _minRating = null;
                    });
                  },
                  child: Text(
                    'Reset All',
                    style: TextStyle(
                      color: AppColors.primaryRose,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Scrollable Filter Sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // Gender Filter
                _buildSectionTitle('Gender', isDark),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _genders.map((g) {
                    final isSel = _selectedGender == g;
                    return _buildFilterChip(g, isSel, () {
                      setState(() => _selectedGender = g);
                    }, isDark);
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Category Filter
                _buildSectionTitle('Category', isDark),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((c) {
                    final isSel = _selectedCategory == c;
                    return _buildFilterChip(c, isSel, () {
                      setState(() => _selectedCategory = c);
                    }, isDark);
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Price Range
                _buildSectionTitle(
                  'Price Range: ₹${_priceRange.start.toInt()} - ₹${_priceRange.end.toInt()}',
                  isDark,
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 500,
                  max: 8000,
                  divisions: 15,
                  activeColor: isDark ? AppColors.champagneGoldLight : AppColors.primaryRose,
                  inactiveColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                  onChanged: (values) {
                    setState(() => _priceRange = values);
                  },
                ),
                const SizedBox(height: 16),

                // Material Filter
                _buildSectionTitle('Material', isDark),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _materials.map((m) {
                    final isSel = _selectedMaterial == m;
                    return _buildFilterChip(m, isSel, () {
                      setState(() => _selectedMaterial = m);
                    }, isDark);
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Color Filter
                _buildSectionTitle('Color / Metal', isDark),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _colors.map((c) {
                    final isSel = _selectedColor == c;
                    return _buildFilterChip(c, isSel, () {
                      setState(() => _selectedColor = c);
                    }, isDark);
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Rating Filter
                _buildSectionTitle('Minimum Rating', isDark),
                Row(
                  children: [null, 4.0, 4.5, 4.8].map((rating) {
                    final label = rating == null ? 'All' : '★ $rating+';
                    final isSel = _minRating == rating;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildFilterChip(label, isSel, () {
                        setState(() => _minRating = rating);
                      }, isDark),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Close',
                    type: ButtonType.outline,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    text: 'Apply Filters',
                    type: ButtonType.gold,
                    onPressed: () {
                      final options = widget.initialOptions.copyWith(
                        gender: _selectedGender == 'All' ? null : _selectedGender!.toLowerCase(),
                        category: _selectedCategory == 'All' ? null : _selectedCategory!.toLowerCase(),
                        style: _selectedStyle == 'All' ? null : _selectedStyle,
                        minPrice: _priceRange.start,
                        maxPrice: _priceRange.end,
                        material: _selectedMaterial == 'All' ? null : _selectedMaterial,
                        color: _selectedColor == 'All' ? null : _selectedColor,
                        minRating: _minRating,
                      );
                      widget.onApply(options);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight)
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? (isDark ? Colors.black : Colors.white)
                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }
}
