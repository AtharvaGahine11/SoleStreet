class Address {
  final String fullName;
  final String mobileNumber;
  final String houseFlat;
  final String street;
  final String city;
  final String state;
  final String pinCode;

  Address({
    required this.fullName,
    required this.mobileNumber,
    required this.houseFlat,
    required this.street,
    required this.city,
    required this.state,
    required this.pinCode,
  });

  String get fullAddress => '$houseFlat, $street, $city, $state - $pinCode';
}
