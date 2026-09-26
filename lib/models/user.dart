import 'address.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final List<DeliveryAddress> addresses;
  final String? defaultAddressId;
  final DateTime joinedDate;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatarUrl = '',
    this.addresses = const [],
    this.defaultAddressId,
    required this.joinedDate,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    List<DeliveryAddress>? addresses,
    String? defaultAddressId,
    DateTime? joinedDate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      addresses: addresses ?? this.addresses,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'addresses': addresses.map((a) => a.toMap()).toList(),
      'defaultAddressId': defaultAddressId,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      addresses: (map['addresses'] as List<dynamic>?)
              ?.map((a) => DeliveryAddress.fromMap(a))
              .toList() ??
          [],
      defaultAddressId: map['defaultAddressId'],
      joinedDate: map['joinedDate'] != null
          ? DateTime.parse(map['joinedDate'])
          : DateTime.now(),
    );
  }
}
