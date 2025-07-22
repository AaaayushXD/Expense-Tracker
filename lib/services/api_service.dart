import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  // Store token in SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  /// Generate token by hitting the auth/token endpoint
  static Future<Map<String, dynamic>> generateToken({
    required String email,
    required String userId,
    String? name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.tokenUrl(userId)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'userId': userId,
          if (name != null) 'name': name,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Store token and user info locally
        await _storeToken(data['token']);
        await _storeUserId(userId);

        return {'success': true, 'token': data['token'], 'user': data['user']};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['message'] ?? 'Failed to generate token',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Store token in SharedPreferences
  static Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Store user ID in SharedPreferences
  static Future<void> _storeUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  /// Get stored token
  static Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get stored user ID
  static Future<String?> getStoredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Clear stored token and user data
  static Future<void> clearStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  /// Check if user has a valid token
  static Future<bool> hasValidToken() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  /// Make authenticated API requests
  static Future<http.Response> authenticatedRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final token = await getStoredToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      ...?headers,
    };

    final uri = Uri.parse(ApiConfig.getUrl(endpoint));

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(uri, headers: requestHeaders);
      case 'POST':
        return await http.post(
          uri,
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          uri,
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(uri, headers: requestHeaders);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }
}
