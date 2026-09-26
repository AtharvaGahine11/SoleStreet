class DeliveryAddress {
  final String id;
  final String fullName;
  final String phone;
  final String streetAddress;
  final String locality;
  final String city;
  final String state;
  final String pincode;
  final String type; // 'Home', 'Work', 'Other'
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.streetAddress,
    this.locality = '',
    required this.city,
    required this.state,
    required this.pincode,
    this.type = 'Home',
    this.isDefault = false,
  });

  String get formattedAddress =>
      '$streetAddress, ${locality.isNotEmpty ? '$locality, ' : ''}$city, $state - $pincode';

  DeliveryAddress copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? streetAddress,
    String? locality,
    String? city,
    String? state,
    String? pincode,
    String? type,
    bool? isDefault,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      streetAddress: streetAddress ?? this.streetAddress,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'streetAddress': streetAddress,
      'locality': locality,
      'city': city,
      'state': state,
      'pincode': pincode,
      'type': type,
      'isDefault': isDefault,
    };
  }

  factory DeliveryAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryAddress(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      streetAddress: map['streetAddress'] ?? '',
      locality: map['locality'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      type: map['type'] ?? 'Home',
      isDefault: map['isDefault'] ?? false,
    );
  }
}
