import '../models/user.dart';
import '../models/address.dart';
import '../data/dummy_user_data.dart';

class AuthService {
  UserProfile? _currentUser = DummyUserData.defaultProfile;
  bool _isAuthenticated = true;

  UserProfile? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<UserProfile> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = DummyUserData.defaultProfile.copyWith(email: email);
    _isAuthenticated = true;
    return _currentUser!;
  }

  Future<UserProfile> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      joinedDate: DateTime.now(),
      addresses: [DummyUserData.defaultAddress],
      defaultAddressId: DummyUserData.defaultAddress.id,
    );
    _isAuthenticated = true;
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _isAuthenticated = false;
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }

  Future<void> addAddress(DeliveryAddress address) async {
    if (_currentUser == null) return;
    final updatedList = List<DeliveryAddress>.from(_currentUser!.addresses);
    if (address.isDefault) {
      for (int i = 0; i < updatedList.length; i++) {
        updatedList[i] = updatedList[i].copyWith(isDefault: false);
      }
    }
    updatedList.add(address);
    _currentUser = _currentUser!.copyWith(
      addresses: updatedList,
      defaultAddressId: address.isDefault ? address.id : _currentUser!.defaultAddressId,
    );
  }

  Future<void> updateAddress(DeliveryAddress address) async {
    if (_currentUser == null) return;
    final updatedList = List<DeliveryAddress>.from(_currentUser!.addresses);
    final index = updatedList.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      if (address.isDefault) {
        for (int i = 0; i < updatedList.length; i++) {
          updatedList[i] = updatedList[i].copyWith(isDefault: false);
        }
      }
      updatedList[index] = address;
      _currentUser = _currentUser!.copyWith(
        addresses: updatedList,
        defaultAddressId: address.isDefault ? address.id : _currentUser!.defaultAddressId,
      );
    }
  }

  Future<void> deleteAddress(String addressId) async {
    if (_currentUser == null) return;
    final updatedList = _currentUser!.addresses.where((a) => a.id != addressId).toList();
    String? newDefaultId = _currentUser!.defaultAddressId;
    if (newDefaultId == addressId && updatedList.isNotEmpty) {
      newDefaultId = updatedList.first.id;
      updatedList[0] = updatedList[0].copyWith(isDefault: true);
    }
    _currentUser = _currentUser!.copyWith(
      addresses: updatedList,
      defaultAddressId: newDefaultId,
    );
  }
}
