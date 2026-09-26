import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/address.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? phone, String? avatarUrl}) async {
    await _authService.updateProfile(name: name, phone: phone, avatarUrl: avatarUrl);
    notifyListeners();
  }

  Future<void> addAddress(DeliveryAddress address) async {
    await _authService.addAddress(address);
    notifyListeners();
  }

  Future<void> updateAddress(DeliveryAddress address) async {
    await _authService.updateAddress(address);
    notifyListeners();
  }

  Future<void> deleteAddress(String addressId) async {
    await _authService.deleteAddress(addressId);
    notifyListeners();
  }
}
