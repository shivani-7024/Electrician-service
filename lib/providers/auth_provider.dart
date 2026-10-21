import 'package:flutter/material.dart';
import '../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? _currentUser = const UserProfile(
    id: 'user-001',
    name: 'Rahul Verma',
    phone: '+91 98765 12345',
    email: 'rahul.verma@example.com',
    addresses: [
      'Flat 402, Royal Residency, Station Road',
      'Plot 55, Shiv Vihar, Bypass Road',
    ],
    defaultAddress: 'Flat 402, Royal Residency, Station Road',
  );

  bool _isLoggedIn = true;
  bool _isLoading = false;
  String? _otpSentTo;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get otpSentTo => _otpSentTo;

  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _otpSentTo = phone;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> verifyOtp(String otp, {String? name, String? address}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    // Simulated verification
    _isLoggedIn = true;
    _currentUser = UserProfile(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? _currentUser?.name ?? 'Customer',
      phone: _otpSentTo ?? _currentUser?.phone ?? '+91 98765 00000',
      email: _currentUser?.email ?? '',
      addresses: address != null ? [address] : (_currentUser?.addresses ?? ['Default Address']),
      defaultAddress: address ?? (_currentUser?.defaultAddress ?? 'Default Address'),
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void continueAsGuest() {
    _isLoggedIn = true;
    _currentUser = const UserProfile(
      id: 'guest-user',
      name: 'Valued Guest',
      phone: '',
      email: '',
      addresses: [],
      defaultAddress: '',
    );
    notifyListeners();
  }

  void updateProfile({String? name, String? email, String? defaultAddress}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        defaultAddress: defaultAddress,
      );
      notifyListeners();
    }
  }

  void addAddress(String newAddress) {
    if (_currentUser != null && newAddress.trim().isNotEmpty) {
      final updated = List<String>.from(_currentUser!.addresses)..add(newAddress);
      _currentUser = _currentUser!.copyWith(
        addresses: updated,
        defaultAddress: newAddress,
      );
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
