import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  String? _selectedSize;
  late String _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.colors.isNotEmpty ? widget.product.colors.first : 'Default';
    if (widget.product.availableSizes.isNotEmpty) {
      _selectedSize = widget.product.availableSizes.first;
    }
  }

  void _handleAddToCart(AppState appState, {bool isBuyNow = false}) {
    if (_selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a size first!'),
          backgroundColor: AppTheme.primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    appState.addToCart(
      widget.product,
      _selectedSize!,
      _selectedColor,
      quantity: _quantity,
    );

    if (isBuyNow) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CheckoutScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${widget.product.name} (Size: $_selectedSize) to Cart! 🛒'),
          backgroundColor: AppTheme.lightTextPrimary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getColorFromLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('red')) return Colors.redAccent;
    if (lower.contains('blue')) return Colors.blueAccent;
    if (lower.contains('black')) return Colors.black;
    if (lower.contains('white')) return Colors.white;
    if (lower.contains('green')) return Colors.green;
    if (lower.contains('yellow')) return Colors.amber;
    if (lower.contains('grey') || lower.contains('gray')) return Colors.grey;
    return AppTheme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isWishlisted = appState.isInWishlist(widget.product.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final imageList = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.image];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceXL,
                    vertical: AppTheme.spaceMD,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 18,
                            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                          ),
                        ),
                      ),
                      Text(
                        widget.product.brand.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 1.5,
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => appState.toggleWishlist(widget.product),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isWishlisted
                                ? AppTheme.primaryColor
                                : (isDark ? AppTheme.darkSurface : AppTheme.lightSurface),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isWishlisted
                                  ? Colors.transparent
                                  : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                            ),
                          ),
                          child: Icon(
                            isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 18,
                            color: isWishlisted
                                ? Colors.white
                                : (isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Large Product Hero Image Container
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.imageContainerColor(isDark),
                            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                            border: Border.all(
                              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                            ),
                          ),
                          padding: const EdgeInsets.all(AppTheme.spaceXL),
                          child: Hero(
                            tag: 'product_img_${widget.product.id}',
                            child: Image.network(
                              imageList[_selectedImageIndex],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.sports_basketball_rounded,
                                size: 80,
                                color: isDark ? Colors.white24 : Colors.black26,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.spaceMD),

                        // Image Gallery Thumbnails Row
                        if (imageList.length > 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              imageList.length,
                              (index) => GestureDetector(
                                onTap: () => setState(() => _selectedImageIndex = index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.all(4),
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: AppTheme.imageContainerColor(isDark),
                                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                                    border: Border.all(
                                      color: _selectedImageIndex == index
                                          ? (isDark ? Colors.white : AppTheme.lightTextPrimary)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Image.network(
                                    imageList[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: AppTheme.spaceXL),

                        // Brand & Product Title
                        Text(
                          widget.product.brand.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.product.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                          ),
                        ),

                        const SizedBox(height: AppTheme.spaceSM),

                        // Rating Badge ★ 4.8 (342 reviews)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: AppTheme.accentGold),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.product.rating}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${widget.product.reviewCount} reviews)',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppTheme.spaceMD),

                        // Price Row ₹7,499  ₹9,999  25% OFF
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              widget.product.formattedPrice,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                              ),
                            ),
                            if (widget.product.originalPrice > widget.product.price) ...[
                              const SizedBox(width: 10),
                              Text(
                                widget.product.formattedOriginalPrice,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.emeraldGreen.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                                ),
                                child: Text(
                                  '${widget.product.discountPercentage}% OFF',
                                  style: const TextStyle(
                                    color: AppTheme.emeraldGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: AppTheme.spaceXL),

                        // Size Selection Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Size',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'Size Guide',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spaceSM),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.product.availableSizes.map((size) {
                            final isSelected = _selectedSize == size;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedSize = size),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 56,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? Colors.white : AppTheme.lightTextPrimary)
                                      : (isDark ? AppTheme.darkSurface : AppTheme.lightSurface),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color: isSelected
                                          ? (isDark ? AppTheme.lightTextPrimary : Colors.white)
                                          : (isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: AppTheme.spaceXL),

                        // Color Selection Section (Circular Selectors)
                        if (widget.product.colors.isNotEmpty) ...[
                          Text(
                            'Select Color',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spaceSM),
                          Wrap(
                            spacing: 12,
                            children: widget.product.colors.map((colorLabel) {
                              final isSelected = _selectedColor == colorLabel;
                              final circleColor = _getColorFromLabel(colorLabel);
                              return GestureDetector(
                                onTap: () => setState(() => _selectedColor = colorLabel),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? (isDark ? Colors.white : AppTheme.lightTextPrimary)
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: circleColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      colorLabel,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: AppTheme.spaceXL),
                        ],

                        // Quantity Selector Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                              ),
                            ),
                            Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: isDark ? AppTheme.darkSurface : AppTheme.lightImageContainer,
                                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                                border: Border.all(
                                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                      }
                                    },
                                    icon: const Icon(Icons.remove_rounded, size: 16),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 36),
                                  ),
                                  Text(
                                    '$_quantity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => setState(() => _quantity++),
                                    icon: const Icon(Icons.add_rounded, size: 16),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 36),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppTheme.spaceXL),

                        // Description Section
                        Text(
                          'About Product',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceSM),
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: AppTheme.spaceXL),

                        // Product Information Specs Table
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spaceLG),
                          decoration: AppTheme.cardDecoration(isDark, borderRadius: AppTheme.radiusLG),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Specifications',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spaceMD),
                              _buildSpecRow('Material', 'Premium Leather & Breathable Mesh', isDark),
                              _buildSpecRow('Sole', 'Cushioned Air Max Rubber Outsole', isDark),
                              _buildSpecRow('Fit', 'True to Size (Regular)', isDark),
                              _buildSpecRow('Warranty', '6 Months Brand Warranty', isDark),
                              _buildSpecRow('Availability', 'In Stock (Fast Shipping)', isDark),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppTheme.spaceSection),
                      ],
                    ),
                  ),
                ),

                // Bottom Sticky Action Bar
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceLG),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Add to Cart (Outlined)
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => _handleAddToCart(appState, isBuyNow: false),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                              ),
                            ),
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: AppTheme.spaceMD),

                      // Buy Now (Solid Primary)
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => _handleAddToCart(appState, isBuyNow: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                              ),
                            ),
                            child: const Text(
                              'Buy Now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ),
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
  }

  Widget _buildSpecRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

