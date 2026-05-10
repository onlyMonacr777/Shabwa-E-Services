import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  bool _isLoggedIn = false;

  String _userRole = 'citizen';

  bool get isLoggedIn => _isLoggedIn;

  String get userRole => _userRole;

  void login({
    required String role,
  }) {
    _isLoggedIn = true;
    _userRole = role;

    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userRole = 'citizen';

    notifyListeners();
  }

  void setUserRole(String role) {
    _userRole = role;

    notifyListeners();
  }
}