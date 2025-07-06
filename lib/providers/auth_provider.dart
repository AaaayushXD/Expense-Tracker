import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Initialize auth provider
  Future<void> initialize() async {
    await _authService.initialize();
    _user = _authService.currentUser;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await _authService.login(email, password);

      if (result['success']) {
        _user = result['user'];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(result['message']);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Signup
  Future<bool> signup(String name, String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await _authService.signup(name, email, password);

      if (result['success']) {
        _user = result['user'];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(result['message']);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _user = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Logout failed');
      _setLoading(false);
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final success = await _authService.refreshToken();
      if (success) {
        _user = _authService.currentUser;
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}
