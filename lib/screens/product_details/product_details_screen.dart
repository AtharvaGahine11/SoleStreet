import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../models/product.dart';
import '../../models/cart_item.dart';
import '../../models/review.dart';
import '../../utils/helpers.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/compare_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/lumora_image.dart';
import '../../widgets/price_widget.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/quantity_selector.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/size_guide_dialog.dart';
import '../../widgets/product_card.dart';
import '../checkout/checkout_screen.dart';
import 'image_gallery_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;
  int _quantity = 1;
  late String _selectedColor;
  late String _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.availableColors.isNotEmpty
        ? widget.product.availableColors.first
        : widget.product.color;
    _selectedSize = widget.product.availableSizes.isNotEmpty
        ? widget.product.availableSizes.first
        : 'Standard Fit';
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _openGallery(int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageGalleryScreen(
          images: widget.product.images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wishlistProvider = context.watch<WishlistProvider>();
    final compareProvider = context.watch<CompareProvider>();
    final isFavorite = wishlistProvider.isInWishlist(widget.product.id);
    final isInCompare = compareProvider.isInCompare(widget.product.id);
    final relatedProducts = context.read<ProductProvider>().getRelatedProducts(widget.product);

    final estimatedDelivery = AppHelpers.getEstimatedDeliveryDate(daysToAdd: 4);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // Scrollable Product Details Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image Carousel Section
                Stack(
                  children: [
                    SliverImageCarousel(
                      images: widget.product.images,
                      controller: _imageController,
                      onPageChanged: (i) => setState(() => _currentImageIndex = i),
                      onTap: () => _openGallery(_currentImageIndex),
                      heroTag: 'product_${widget.product.id}',
                    ),

                    // Top App Bar Buttons (Back, Share, Wishlist, Compare)
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCircularButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.pop(context),
                              isDark: isDark,
                            ),
                            Row(
                              children: [
                                // Compare toggle
                                _buildCircularButton(
                                  icon: isInCompare ? Icons.compare_arrows_rounded : Icons.compare_arrows_outlined,
                                  color: isInCompare ? AppColors.champagneGold : null,
                                  onTap: () {
                                    final added = context.read<CompareProvider>().toggleCompare(widget.product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(added
                                            ? 'Added to comparison sheet'
                                            : 'Removed from comparison sheet'),
                                        duration: const Duration(seconds: 1),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 8),
                                // Share
                                _buildCircularButton(
                                  icon: Icons.share_outlined,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Sharing "${widget.product.name}" with friends!'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 8),
                                // Wishlist
                                _buildCircularButton(
                                  icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isFavorite ? AppColors.primaryRose : null,
                                  onTap: () {
                                    wishlistProvider.toggleWishlist(widget.product);
                                  },
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Dot Indicators
                    if (widget.product.images.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(widget.product.images.length, (index) {
                            final isSel = _currentImageIndex == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: isSel ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.champagneGold : Colors.white60,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),

                // Main Info Container
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand & New/Sale Badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.brand.toUpperCase(),
                            style: AppTextStyles.productBrand(fontSize: 13),
                          ),
                          if (widget.product.stock < 10)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Only ${widget.product.stock} left in stock',
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Product Title
                      Text(
                        widget.product.name,
                        style: AppTextStyles.heroHeading(isDark: isDark, fontSize: 24),
                      ),
                      const SizedBox(height: 10),

                      // Rating & Reviews row
                      Row(
                        children: [
                          RatingWidget(
                            rating: widget.product.rating,
                            reviewCount: widget.product.reviewCount,
                            iconSize: 16,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Verified Atelier Quality',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Price Section
                      PriceWidget(
                        price: widget.product.price,
                        originalPrice: widget.product.originalPrice,
                        isLarge: true,
                      ),
                      const SizedBox(height: 20),

                      // Free delivery estimate box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.champagneGold.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.local_shipping_outlined,
                                color: AppColors.champagneGold,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Complimentary Express Delivery',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Estimated arrival by $estimatedDelivery',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Color Options
                      if (widget.product.availableColors.isNotEmpty) ...[
                        Text(
                          'COLOR: $_selectedColor',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: widget.product.availableColors.map((color) {
                            final isSel = _selectedColor == color;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColor = color),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? (isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight)
                                      : (isDark ? AppColors.cardDark : AppColors.cardLight),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSel
                                        ? Colors.transparent
                                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  color,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel
                                        ? (isDark ? Colors.black : Colors.white)
                                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Size Options with Size Guide Trigger
                      if (widget.product.availableSizes.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SELECT SIZE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => SizeGuideDialog.show(context, category: widget.product.category),
                              child: Row(
                                children: [
                                  const Icon(Icons.straighten, size: 15, color: AppColors.champagneGold),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Size Guide',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: widget.product.availableSizes.map((size) {
                            final isSel = _selectedSize == size;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedSize = size),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? (isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight)
                                      : (isDark ? AppColors.cardDark : AppColors.cardLight),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSel
                                        ? Colors.transparent
                                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel
                                        ? (isDark ? Colors.black : Colors.white)
                                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Description
                      Text(
                        'ABOUT THE PIECE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: AppTextStyles.bodyMedium(isDark: isDark, fontSize: 14.5),
                      ),
                      const SizedBox(height: 24),

                      // Material & Craftsmanship
                      Text(
                        'MATERIAL & FINISH',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.diamond_outlined, color: AppColors.champagneGold, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.product.material,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Product Features List
                      Text(
                        'HIGHLIGHTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...widget.product.features.map((feature) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.champagneGold),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 24),

                      // Care Instructions
                      Text(
                        'CARE & MAINTENANCE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...widget.product.careInstructions.map((inst) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  inst,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 30),

                      // Customer Reviews Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CUSTOMER REVIEWS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                            ),
                          ),
                          Text(
                            '${widget.product.reviews.length} Reviews',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.champagneGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      if (widget.product.reviews.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : AppColors.cardLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              'Be the first to review this atelier masterpiece!',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        )
                      else
                        ...widget.product.reviews.map((r) => _buildReviewCard(r, isDark)),
                      const SizedBox(height: 30),

                      // Related Products
                      if (relatedProducts.isNotEmpty) ...[
                        Text(
                          'YOU MAY ALSO LOVE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 260,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedProducts.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              final related = relatedProducts[index];
                              return ProductCard(
                                product: related,
                                width: 170,
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailsScreen(product: related),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight).withValues(alpha: 0.95),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 0.8,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Quantity
                  QuantitySelector(
                    quantity: _quantity,
                    onChanged: (q) => setState(() => _quantity = q),
                  ),
                  const SizedBox(width: 12),

                  // Add to Bag Button
                  Expanded(
                    child: CustomButton(
                      text: 'ADD TO BAG',
                      type: ButtonType.outline,
                      height: 48,
                      onPressed: () {
                        context.read<CartProvider>().addToCart(
                              widget.product,
                              quantity: _quantity,
                              color: _selectedColor,
                              size: _selectedSize,
                            );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Added $_quantity piece(s) to your bag',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.textPrimaryLight,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Buy Now Button
                  Expanded(
                    child: CustomButton(
                      text: 'BUY NOW',
                      type: ButtonType.gold,
                      height: 48,
                      onPressed: () {
                        final tempItem = CartItem(
                          product: widget.product,
                          quantity: _quantity,
                          selectedColor: _selectedColor,
                          selectedSize: _selectedSize,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(directBuyItem: tempItem),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 19,
          color: color ?? (isDark ? Colors.white : AppColors.textPrimaryLight),
        ),
      ),
    );
  }

  Widget _buildReviewCard(ProductReview review, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.champagneGold.withValues(alpha: 0.2),
                    child: Text(
                      review.userName.isNotEmpty ? review.userName[0] : 'U',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.champagneGold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    review.userName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  if (review.isVerified) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.verified, size: 14, color: AppColors.success),
                  ],
                ],
              ),
              RatingWidget(rating: review.rating, showNumber: false, iconSize: 13),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppHelpers.formatDate(review.date),
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class SliverImageCarousel extends StatelessWidget {
  final List<String> images;
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onTap;
  final String heroTag;

  const SliverImageCarousel({
    super.key,
    required this.images,
    required this.controller,
    required this.onPageChanged,
    required this.onTap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.46;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: PageView.builder(
        controller: controller,
        itemCount: images.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: onTap,
            child: LumoraImage(
              imageUrl: images[index],
              fit: BoxFit.cover,
              borderRadius: 0,
              heroTag: index == 0 ? heroTag : null,
            ),
          );
        },
      ),
    );
  }
}
