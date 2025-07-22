import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static final Dio _dio = Dio();
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  /// Generate token by hitting the auth/token endpoint
  static Future<Map<String, dynamic>> generateToken({
    required String email,
    required String userId,
    String? name,
  }) async {
    try {
      print('Generating token for user: $email with ID: $userId');
      print("Requesting token from: ${ApiConfig.tokenUrl(userId)}");

      final response = await _dio.get(
        ApiConfig.tokenUrl(userId),
        data: {
          'email': email,
          'userId': userId,
          if (name != null) 'name': name,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['data'];
        await _storeToken(token);
        await _storeUserId(userId);
        return {
          'success': true,
          'token': token,
          'message': response.data['message'],
        };
      } else {
        return {
          'success': false,
          'error': response.data['message'] ?? 'Failed to generate token',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> _storeUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> getStoredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<void> clearStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  static Future<bool> hasValidToken() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  /// Make authenticated API requests
  static Future<Response> authenticatedRequest(
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

    final url = ApiConfig.getUrl(endpoint);

    switch (method.toUpperCase()) {
      case 'GET':
        return await _dio.get(url, options: Options(headers: requestHeaders));
      case 'POST':
        return await _dio.post(
          url,
          data: body,
          options: Options(headers: requestHeaders),
        );
      case 'PUT':
        return await _dio.put(
          url,
          data: body,
          options: Options(headers: requestHeaders),
        );
      case 'DELETE':
        return await _dio.delete(
          url,
          options: Options(headers: requestHeaders),
        );
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConfig.registerUrl,
      data: {'name': name, 'email': email, 'password': password},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return response.data;
  }
}
