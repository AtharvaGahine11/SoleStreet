import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/address.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/price_summary.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: 'Atharva Gahine');
  final TextEditingController _mobileController = TextEditingController(text: '9876543210');
  final TextEditingController _houseController = TextEditingController(text: 'Flat 402, Skyline Towers');
  final TextEditingController _streetController = TextEditingController(text: 'MG Road, Indiranagar');
  final TextEditingController _cityController = TextEditingController(text: 'Bengaluru');
  final TextEditingController _stateController = TextEditingController(text: 'Karnataka');
  final TextEditingController _pinController = TextEditingController(text: '560038');

  String _selectedDeliveryMethod = 'Standard Delivery (2-4 Days)';
  double _deliveryFeeAmount = 99;
  String _selectedPaymentMethod = 'UPI (Google Pay / PhonePe)';

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _deliveryFeeAmount = appState.deliveryFee;
  }

  void _onDeliveryMethodChanged(String method, double fee) {
    setState(() {
      _selectedDeliveryMethod = method;
      _deliveryFeeAmount = fee;
    });
  }

  void _handlePlaceOrder(AppState appState) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required address fields correctly.'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      return;
    }

    final address = Address(
      fullName: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      houseFlat: _houseController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pinCode: _pinController.text.trim(),
    );

    final newOrder = appState.placeOrder(
      address: address,
      deliveryMethod: _selectedDeliveryMethod,
      paymentMethod: _selectedPaymentMethod,
      deliveryFeeChoice: _deliveryFeeAmount,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(order: newOrder),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _houseController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double grandTotal = appState.cartSubtotal - appState.couponDiscountAmount + _deliveryFeeAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppTheme.spaceXL),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Delivery Address Section
                          _buildSectionHeader('Delivery Address 📍', isDark),
                          const SizedBox(height: AppTheme.spaceMD),

                          _buildTextField(_nameController, 'Full Name', Icons.person_outline, isDark, required: true),
                          const SizedBox(height: AppTheme.spaceSM),
                          _buildTextField(_mobileController, 'Mobile Number', Icons.phone_android_outlined, isDark,
                              keyboardType: TextInputType.phone, required: true),
                          const SizedBox(height: AppTheme.spaceSM),
                          _buildTextField(_houseController, 'Flat / Building No.', Icons.home_outlined, isDark, required: true),
                          const SizedBox(height: AppTheme.spaceSM),
                          _buildTextField(_streetController, 'Street / Area', Icons.location_on_outlined, isDark, required: true),
                          const SizedBox(height: AppTheme.spaceSM),
                          Row(
                            children: [
                              Expanded(child: _buildTextField(_cityController, 'City', Icons.location_city_outlined, isDark, required: true)),
                              const SizedBox(width: AppTheme.spaceSM),
                              Expanded(child: _buildTextField(_stateController, 'State', Icons.map_outlined, isDark, required: true)),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spaceSM),
                          _buildTextField(_pinController, 'PIN Code', Icons.pin_drop_outlined, isDark,
                              keyboardType: TextInputType.number, required: true),

                          const SizedBox(height: AppTheme.spaceXXL),

                          // 2. Delivery Speed Section
                          _buildSectionHeader('Delivery Method 🚚', isDark),
                          const SizedBox(height: AppTheme.spaceMD),

                          _buildDeliveryRadio(
                            'Standard Delivery (2-4 Days)',
                            appState.cartSubtotal >= 5000 ? 0 : 99,
                            'Free delivery on orders over ₹5,000',
                            isDark,
                          ),
                          const SizedBox(height: AppTheme.spaceSM),
                          _buildDeliveryRadio(
                            'Express Delivery (24-48 Hours)',
                            149,
                            'Priority dispatch via Air Express',
                            isDark,
                          ),

                          const SizedBox(height: AppTheme.spaceXXL),

                          // 3. Payment Method Section
                          _buildSectionHeader('Payment Method 💳', isDark),
                          const SizedBox(height: AppTheme.spaceMD),

                          _buildPaymentRadio('UPI (Google Pay / PhonePe)', Icons.qr_code_scanner_rounded, isDark),
                          const SizedBox(height: AppTheme.spaceSM),
                          _buildPaymentRadio('Credit / Debit Card', Icons.credit_card_rounded, isDark),
                          const SizedBox(height: AppTheme.spaceSM),
                          _buildPaymentRadio('Cash on Delivery (COD)', Icons.payments_outlined, isDark),

                          const SizedBox(height: AppTheme.spaceXXL),

                          // Order Summary Review Card
                          PriceSummaryCard(
                            subtotal: appState.cartSubtotal,
                            discount: appState.couponDiscountAmount,
                            delivery: _deliveryFeeAmount,
                            total: grandTotal,
                            appliedCoupon: appState.appliedCoupon,
                          ),

                          const SizedBox(height: AppTheme.spaceSection),
                        ],
                      ),
                    ),
                  ),
                ),

                // Place Order Sticky Button Footer
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
                      onPressed: () => _handlePlaceOrder(appState),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        foregroundColor: isDark ? AppTheme.lightTextPrimary : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                        ),
                      ),
                      child: Text(
                        'Place Order • ₹${grandTotal.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool isDark, {
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $label';
              }
              return null;
            }
          : null,
      style: TextStyle(
        fontSize: 13.5,
        color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
          fontSize: 12.5,
        ),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
        ),
        filled: true,
        fillColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          borderSide: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          borderSide: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          borderSide: BorderSide(
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildDeliveryRadio(String method, double fee, String subtitle, bool isDark) {
    final isSelected = _selectedDeliveryMethod == method;

    return GestureDetector(
      onTap: () => _onDeliveryMethodChanged(method, fee),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : AppTheme.lightTextPrimary)
                : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: method,
              groupValue: _selectedDeliveryMethod,
              activeColor: isDark ? Colors.white : AppTheme.lightTextPrimary,
              onChanged: (val) => _onDeliveryMethodChanged(method, fee),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              fee == 0 ? 'FREE' : '₹${fee.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: fee == 0
                    ? AppTheme.emeraldGreen
                    : (isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRadio(String method, IconData icon, bool isDark) {
    final isSelected = _selectedPaymentMethod == method;

    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : AppTheme.lightTextPrimary)
                : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: method,
              groupValue: _selectedPaymentMethod,
              activeColor: isDark ? Colors.white : AppTheme.lightTextPrimary,
              onChanged: (val) => setState(() => _selectedPaymentMethod = method),
            ),
            Icon(
              icon,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              method,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

