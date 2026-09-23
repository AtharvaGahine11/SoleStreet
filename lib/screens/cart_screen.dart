import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/price_summary.dart';
import '../widgets/empty_state_widget.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  void _applyCoupon(AppState appState) {
    if (_couponController.text.trim().isEmpty) return;

    final result = appState.applyCoupon(_couponController.text);
    final bool isSuccess = result['success'];
    final String message = result['message'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? AppTheme.emeraldGreen : AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    if (isSuccess) {
      _couponController.clear();
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final cart = appState.cart;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
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
                        'Shopping Cart',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                        ),
                      ),
                      if (cart.isNotEmpty)
                        GestureDetector(
                          onTap: () => appState.clearCart(),
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Cart Content Body
                Expanded(
                  child: cart.isEmpty
                      ? EmptyStateWidget(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Your cart is empty',
                          message: 'Save your favorite sneakers and step into your style.',
                          buttonText: 'Explore Kicks',
                          onButtonPressed: () {
                            appState.setSelectedCategory('All');
                          },
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(AppTheme.spaceXL),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Cart Items List
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cart.length,
                                itemBuilder: (context, index) {
                                  final item = cart[index];
                                  return CartItemCard(
                                    item: item,
                                    onIncrement: () => appState.updateCartQuantity(index, 1),
                                    onDecrement: () => appState.updateCartQuantity(index, -1),
                                    onRemove: () => appState.removeFromCart(index),
                                  );
                                },
                              ),

                              const SizedBox(height: AppTheme.spaceMD),

                              // Promo Code Helpers
                              Container(
                                padding: const EdgeInsets.all(AppTheme.spaceMD),
                                decoration: AppTheme.cardDecoration(isDark, borderRadius: AppTheme.radiusMD),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Available Promo Codes:',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppTheme.spaceSM),
                                    Row(
                                      children: [
                                        _buildSampleCouponTag('SOLE10', '10% OFF', isDark),
                                        const SizedBox(width: 8),
                                        _buildSampleCouponTag('NEWUSER', '15% OFF', isDark),
                                        const SizedBox(width: 8),
                                        _buildSampleCouponTag('KICK20', '20% OFF', isDark),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: AppTheme.spaceMD),

                              // Promo Code Input Box
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                                  border: Border.all(
                                    color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.confirmation_number_outlined,
                                      size: 18,
                                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _couponController,
                                        textCapitalization: TextCapitalization.characters,
                                        style: TextStyle(
                                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Enter Promo Code',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                            fontSize: 13,
                                          ),
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _applyCoupon(appState),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDark ? Colors.white : AppTheme.lightTextPrimary,
                                        foregroundColor: isDark ? AppTheme.lightTextPrimary : Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text(
                                        'Apply',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: AppTheme.spaceXL),

                              // Order Summary Card
                              PriceSummaryCard(
                                subtotal: appState.cartSubtotal,
                                discount: appState.couponDiscountAmount,
                                delivery: appState.deliveryFee,
                                total: appState.cartGrandTotal,
                                appliedCoupon: appState.appliedCoupon,
                                onRemoveCoupon: () => appState.removeCoupon(),
                              ),

                              const SizedBox(height: AppTheme.spaceXXL),
                            ],
                          ),
                        ),
                ),

                // Sticky Bottom Checkout Button
                if (cart.isNotEmpty)
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
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : AppTheme.lightTextPrimary,
                          foregroundColor: isDark ? AppTheme.lightTextPrimary : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Proceed to Checkout',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSampleCouponTag(String code, String desc, bool isDark) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _couponController.text = code;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkBackground : AppTheme.lightImageContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          ),
        ),
        child: Text(
          '$code ($desc)',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
      ),
    );
  }
}

