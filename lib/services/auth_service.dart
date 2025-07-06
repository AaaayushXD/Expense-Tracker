import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _baseUrl =
      'https://api.expense-tracker.com'; // Replace with your actual API URL
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;
  User? _currentUser;

  // Getters
  String? get token => _token;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null;

  // Initialize auth service
  Future<void> initialize() async {
    await _loadTokenFromStorage();
    await _loadUserFromStorage();
  }

  // Load token from shared preferences
  Future<void> _loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  // Load user from shared preferences
  Future<void> _loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      _currentUser = User.fromJson(json.decode(userJson));
    }
  }

  // Save token to shared preferences
  Future<void> _saveTokenToStorage(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _token = token;
  }

  // Save user to shared preferences
  Future<void> _saveUserToStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    _currentUser = user;
  }

  // Clear stored data
  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    _token = null;
    _currentUser = null;
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        final user = User.fromJson(data['user']);

        await _saveTokenToStorage(token);
        await _saveUserToStorage(user);

        return {'success': true, 'message': 'Login successful', 'user': user};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Signup
  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        final token = data['token'];
        final user = User.fromJson(data['user']);

        await _saveTokenToStorage(token);
        await _saveUserToStorage(user);

        return {
          'success': true,
          'message': 'Account created successfully',
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Signup failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      if (_token != null) {
        await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );
      }
    } catch (e) {
      // Ignore logout errors
    } finally {
      await _clearStorage();
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      if (_token == null) return false;

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newToken = data['token'];
        await _saveTokenToStorage(newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get headers with auth token
  Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }
}
