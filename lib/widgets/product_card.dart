import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../screens/product_details_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _heartAnimController;
  late Animation<double> _heartScaleAnimation;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _heartScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.35), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.35, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartAnimController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    super.dispose();
  }

  void _onWishlistTap(AppState appState) {
    _heartAnimController.forward(from: 0.0);
    appState.toggleWishlist(widget.product);
  }

  void _onAddToCart(AppState appState) async {
    if (_isAddingToCart) return;
    setState(() => _isAddingToCart = true);

    String defaultSize = widget.product.availableSizes.isNotEmpty ? widget.product.availableSizes.first : 'UK 8';
    String defaultColor = widget.product.colors.isNotEmpty ? widget.product.colors.first : 'Default';

    appState.addToCart(widget.product, defaultSize, defaultColor);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added ${widget.product.name} to Cart',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTextPrimary,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _isAddingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isWishlisted = appState.isInWishlist(widget.product.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: widget.product),
              ),
            );
          },
      child: Container(
        decoration: AppTheme.cardDecoration(isDark, borderRadius: AppTheme.radiusLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PRODUCT IMAGE CONTAINER AREA
            Expanded(
              flex: 5,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Soft neutral image backdrop
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppTheme.radiusLG - 1),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppTheme.imageContainerColor(isDark),
                      padding: const EdgeInsets.all(AppTheme.spaceMD),
                      child: Hero(
                        tag: 'product_img_${widget.product.id}',
                        child: Image.network(
                          widget.product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.sports_basketball_rounded,
                                size: 44,
                                color: isDark ? Colors.white24 : Colors.black26,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Wishlist Button (Top Right Floating Circle)
                  Positioned(
                    top: AppTheme.spaceSM,
                    right: AppTheme.spaceSM,
                    child: GestureDetector(
                      onTap: () => _onWishlistTap(appState),
                      child: ScaleTransition(
                        scale: _heartScaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkSurface.withValues(alpha: 0.9)
                                : Colors.white.withValues(alpha: 0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 16,
                            color: isWishlisted
                                ? AppTheme.primaryColor
                                : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Discount Badge Pill (Bottom Right inside Image container)
                  if (widget.product.discountPercentage > 0)
                    Positioned(
                      bottom: AppTheme.spaceSM,
                      right: AppTheme.spaceSM,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                        ),
                        child: Text(
                          '-${widget.product.discountPercentage}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 2. PRODUCT DETAILS SECTION
            Padding(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand Name (Uppercase, Muted)
                  Text(
                    widget.product.brand.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Product Title (Max 2 lines, controlled line height for uniform layout)
                  SizedBox(
                    height: 36,
                    child: Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 1.3,
                        color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Rating Row ★ 4.8 (124)
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppTheme.accentGold),
                      const SizedBox(width: 3),
                      Text(
                        '${widget.product.rating}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '(${widget.product.reviewCount})',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.product.formattedPrice,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                        ),
                      ),
                      if (widget.product.originalPrice > widget.product.price) ...[
                        const SizedBox(width: 6),
                        Text(
                          widget.product.formattedOriginalPrice,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 3. FULL WIDTH ADD TO CART BUTTON CTA
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: () => _onAddToCart(appState),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        foregroundColor: isDark ? AppTheme.lightTextPrimary : Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                        ),
                      ),
                      icon: AnimatedRotation(
                        turns: _isAddingToCart ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          _isAddingToCart ? Icons.check_rounded : Icons.add_shopping_cart_rounded,
                          size: 15,
                        ),
                      ),
                      label: Text(
                        _isAddingToCart ? 'Added' : 'Add to Cart',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
    );
  }
}

