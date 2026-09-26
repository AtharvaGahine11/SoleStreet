import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../models/cart_item.dart';
import '../../models/address.dart';
import '../../utils/helpers.dart';
import '../../utils/constants.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/lumora_image.dart';
import '../profile/add_edit_address_screen.dart';
import '../order_success/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final CartItem? directBuyItem;

  const CheckoutScreen({super.key, this.directBuyItem});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0; // 0: Address, 1: Delivery, 2: Payment, 3: Review
  DeliveryAddress? _selectedAddress;
  String _selectedDeliveryOption = 'standard'; // 'standard', 'express'
  String _selectedPaymentMethod = 'UPI'; // 'UPI', 'CARD', 'COD', 'WALLET'

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    final addresses = auth.currentUser?.addresses ?? [];
    if (addresses.isNotEmpty) {
      _selectedAddress = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = context.watch<CartProvider>();
    final authProvider = context.watch<AuthProvider>();
    final addresses = authProvider.currentUser?.addresses ?? [];

    final List<CartItem> items = widget.directBuyItem != null
        ? [widget.directBuyItem!]
        : cartProvider.items;

    final double subtotal = items.fold(0.0, (s, i) => s + i.totalPrice);
    final double discount = widget.directBuyItem != null ? 0.0 : cartProvider.couponDiscount;
    final double deliveryFee = _selectedDeliveryOption == 'express'
        ? AppConstants.expressDeliveryFee
        : (subtotal >= AppConstants.freeDeliveryThreshold ? 0.0 : AppConstants.standardDeliveryFee);
    final double totalAmount = (subtotal - discount + deliveryFee).clamp(0.0, double.infinity);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Step Progress Bar
          _buildProgressIndicator(isDark),

          // Step Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildCurrentStepView(
                items: items,
                subtotal: subtotal,
                discount: discount,
                deliveryFee: deliveryFee,
                totalAmount: totalAmount,
                addresses: addresses,
                isDark: isDark,
              ),
            ),
          ),

          // Bottom Action
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payable',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                      ),
                    ),
                    Text(
                      AppHelpers.formatPrice(totalAmount),
                      style: AppTextStyles.priceLarge(isDark: isDark, fontSize: 18),
                    ),
                  ],
                ),
                const Spacer(),
                CustomButton(
                  text: _currentStep == 3 ? 'CONFIRM & PAY' : 'CONTINUE →',
                  type: ButtonType.gold,
                  width: 170,
                  height: 48,
                  onPressed: () => _handleNextStep(items, subtotal, discount, deliveryFee, totalAmount),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNextStep(
    List<CartItem> items,
    double subtotal,
    double discount,
    double deliveryFee,
    double totalAmount,
  ) async {
    if (_currentStep == 0) {
      if (_selectedAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select or add a delivery address.')),
        );
        return;
      }
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      setState(() => _currentStep = 3);
    } else if (_currentStep == 3) {
      // Place Order
      if (_selectedAddress == null) return;
      final order = await context.read<OrderProvider>().placeOrder(
            items: items,
            subtotal: subtotal,
            discount: discount,
            deliveryFee: deliveryFee,
            totalAmount: totalAmount,
            paymentMethod: _getPaymentMethodLabel(_selectedPaymentMethod),
            deliveryAddress: _selectedAddress!,
          );

      if (order != null && mounted) {
        if (widget.directBuyItem == null) {
          context.read<CartProvider>().clearCart();
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(order: order),
          ),
        );
      }
    }
  }

  String _getPaymentMethodLabel(String method) {
    switch (method) {
      case 'UPI':
        return 'UPI (Google Pay / PhonePe)';
      case 'CARD':
        return 'Credit / Debit Card';
      case 'COD':
        return 'Cash on Delivery';
      case 'WALLET':
        return 'Digital Wallet / Apple Pay';
      default:
        return 'Prepaid';
    }
  }

  Widget _buildProgressIndicator(bool isDark) {
    final steps = ['Address', 'Delivery', 'Payment', 'Review'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isCompleted = _currentStep > index;
          final isCurrent = _currentStep == index;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.success
                        : (isCurrent
                            ? (isDark ? AppColors.champagneGoldLight : AppColors.primaryRose)
                            : (isDark ? AppColors.cardDark : AppColors.cardLight)),
                    border: Border.all(
                      color: isCurrent
                          ? (isDark ? AppColors.champagneGoldLight : AppColors.primaryRose)
                          : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isCurrent ? Colors.white : Colors.grey,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent
                        ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                        : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1.5,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      color: isCompleted
                          ? AppColors.success
                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepView({
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double deliveryFee,
    required double totalAmount,
    required List<DeliveryAddress> addresses,
    required bool isDark,
  }) {
    switch (_currentStep) {
      case 0:
        return _buildAddressStep(addresses, isDark);
      case 1:
        return _buildDeliveryStep(isDark);
      case 2:
        return _buildPaymentStep(isDark);
      case 3:
      default:
        return _buildReviewStep(items, subtotal, discount, deliveryFee, totalAmount, isDark);
    }
  }

  Widget _buildAddressStep(List<DeliveryAddress> addresses, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SELECT DELIVERY ADDRESS',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add New'),
              style: TextButton.styleFrom(foregroundColor: AppColors.champagneGold),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddEditAddressScreen()),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...addresses.map((address) {
          final isSel = _selectedAddress?.id == address.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedAddress = address),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSel
                      ? AppColors.champagneGold
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: isSel ? 1.5 : 0.8,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRadioDot(isSel),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              address.fullName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                address.type,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.champagneGoldLight : AppColors.textSecondaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address.formattedAddress,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Phone: ${address.phone}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDeliveryStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHOOSE DELIVERY SPEED',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
          ),
        ),
        const SizedBox(height: 14),

        // Standard Delivery
        _buildDeliveryCard(
          id: 'standard',
          title: 'Complimentary Standard Express',
          timeEstimate: AppHelpers.getEstimatedDeliveryDate(daysToAdd: 4),
          price: 'FREE',
          description: 'Insured BlueDart courier in signature HEERA heritage velvet box.',
          isDark: isDark,
        ),
        const SizedBox(height: 12),

        // Express Priority
        _buildDeliveryCard(
          id: 'express',
          title: 'Priority Next-Day Atelier Dispatch',
          timeEstimate: AppHelpers.getEstimatedDeliveryDate(daysToAdd: 1),
          price: '₹199',
          description: 'Priority queue packing with personalized wax-sealed gift note.',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildDeliveryCard({
    required String id,
    required String title,
    required String timeEstimate,
    required String price,
    required String description,
    required bool isDark,
  }) {
    final isSel = _selectedDeliveryOption == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedDeliveryOption = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSel ? AppColors.champagneGold : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSel ? 1.5 : 0.8,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRadioDot(isSel),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.champagneGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Arrives by $timeEstimate',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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

  Widget _buildPaymentStep(bool isDark) {
    final paymentMethods = [
      {
        'id': 'UPI',
        'title': 'Instant UPI (GPay, PhonePe, Paytm)',
        'icon': Icons.bolt_rounded,
        'badge': 'RECOMMENDED',
      },
      {
        'id': 'CARD',
        'title': 'Credit / Debit Cards (Visa, Mastercard, Amex)',
        'icon': Icons.credit_card_rounded,
      },
      {
        'id': 'WALLET',
        'title': 'Apple Pay / Digital Wallets',
        'icon': Icons.account_balance_wallet_outlined,
      },
      {
        'id': 'COD',
        'title': 'Cash on Delivery (OTP Verified)',
        'icon': Icons.payments_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT PAYMENT METHOD',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
          ),
        ),
        const SizedBox(height: 14),
        ...paymentMethods.map((pm) {
          final isSel = _selectedPaymentMethod == pm['id'];
          return GestureDetector(
            onTap: () => setState(() => _selectedPaymentMethod = pm['id'] as String),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSel ? AppColors.champagneGold : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: isSel ? 1.5 : 0.8,
                ),
              ),
              child: Row(
                children: [
                  _buildRadioDot(isSel),
                  const SizedBox(width: 12),
                  Icon(pm['icon'] as IconData, size: 22, color: AppColors.champagneGold),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pm['title'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        if (pm['badge'] != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              pm['badge'] as String,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRadioDot(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.champagneGold : Colors.grey.shade400,
          width: 1.8,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.champagneGold,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildReviewStep(
    List<CartItem> items,
    double subtotal,
    double discount,
    double deliveryFee,
    double totalAmount,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ORDER SUMMARY & REVIEW',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
          ),
        ),
        const SizedBox(height: 14),

        // Items Preview
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: LumoraImage(
                        imageUrl: item.product.images.isNotEmpty ? item.product.images.first : '',
                        borderRadius: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Qty: ${item.quantity} • ${item.selectedColor}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      AppHelpers.formatPrice(item.totalPrice),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Destination & Payment method summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Delivery To', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  GestureDetector(
                    onTap: () => setState(() => _currentStep = 0),
                    child: const Text('Change', style: TextStyle(color: AppColors.champagneGold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${_selectedAddress?.fullName} (${_selectedAddress?.phone})\n${_selectedAddress?.formattedAddress}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  GestureDetector(
                    onTap: () => setState(() => _currentStep = 2),
                    child: const Text('Change', style: TextStyle(color: AppColors.champagneGold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _getPaymentMethodLabel(_selectedPaymentMethod),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
