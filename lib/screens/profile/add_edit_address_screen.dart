import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../models/address.dart';
import '../../utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class AddEditAddressScreen extends StatefulWidget {
  final DeliveryAddress? addressToEdit;

  const AddEditAddressScreen({super.key, this.addressToEdit});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _localityController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  String _type = 'Home';
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final a = widget.addressToEdit;
    _nameController = TextEditingController(text: a?.fullName ?? 'Atharva S.');
    _phoneController = TextEditingController(text: a?.phone ?? '+91 98765 43210');
    _streetController = TextEditingController(text: a?.streetAddress ?? '');
    _localityController = TextEditingController(text: a?.locality ?? '');
    _cityController = TextEditingController(text: a?.city ?? 'Bengaluru');
    _stateController = TextEditingController(text: a?.state ?? 'Karnataka');
    _pincodeController = TextEditingController(text: a?.pincode ?? '560038');
    _type = a?.type ?? 'Home';
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _localityController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      final address = DeliveryAddress(
        id: widget.addressToEdit?.id ?? 'addr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        streetAddress: _streetController.text.trim(),
        locality: _localityController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        type: _type,
        isDefault: _isDefault,
      );

      final auth = context.read<AuthProvider>();
      if (widget.addressToEdit != null) {
        auth.updateAddress(address);
      } else {
        auth.addAddress(address);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.addressToEdit != null ? 'Edit Address' : 'Add New Address',
          style: AppTextStyles.sectionHeading(isDark: isDark, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact details
              _buildFieldTitle('CONTACT DETAILS', isDark),
              TextFormField(
                controller: _nameController,
                validator: (v) => AppValidators.validateRequired(v, 'Full Name'),
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: AppValidators.validatePhone,
                decoration: const InputDecoration(labelText: 'Mobile Phone'),
              ),
              const SizedBox(height: 24),

              // Address details
              _buildFieldTitle('ADDRESS DETAILS', isDark),
              TextFormField(
                controller: _streetController,
                validator: (v) => AppValidators.validateRequired(v, 'Flat / House / Street Address'),
                decoration: const InputDecoration(labelText: 'Flat, House No., Building, Street'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _localityController,
                decoration: const InputDecoration(labelText: 'Area, Locality or Landmark (Optional)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      validator: (v) => AppValidators.validateRequired(v, 'City'),
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      validator: AppValidators.validatePincode,
                      decoration: const InputDecoration(labelText: 'Pincode'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stateController,
                validator: (v) => AppValidators.validateRequired(v, 'State'),
                decoration: const InputDecoration(labelText: 'State'),
              ),
              const SizedBox(height: 24),

              // Address Type
              _buildFieldTitle('ADDRESS TYPE', isDark),
              Row(
                children: ['Home', 'Work', 'Other'].map((type) {
                  final isSel = _type == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: isSel,
                      selectedColor: isDark ? AppColors.champagneGoldLight : AppColors.textPrimaryLight,
                      labelStyle: TextStyle(
                        color: isSel
                            ? (isDark ? Colors.black : Colors.white)
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _type = type);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Default Switch
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                activeTrackColor: AppColors.champagneGold,
                title: const Text('Set as Default Delivery Address', style: TextStyle(fontSize: 13.5)),
                value: _isDefault,
                onChanged: (val) => setState(() => _isDefault = val),
              ),
              const SizedBox(height: 24),

              // Save Button
              CustomButton(
                text: 'SAVE ADDRESS',
                type: ButtonType.gold,
                onPressed: _saveAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
        ),
      ),
    );
  }
}
