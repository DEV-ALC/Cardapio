import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  static final AuthProvider instance = AuthProvider._internal();
  AuthProvider._internal();

  bool isLoggedIn = false;

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }
}
