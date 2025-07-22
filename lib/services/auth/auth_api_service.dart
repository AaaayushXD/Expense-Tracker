import 'package:dio/dio.dart';
import '../../config/api_config.dart';

class AuthApiService {
  static final Dio _dio = Dio();

  // Add a new user (register)
  static Future<Response> addNewUser({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _dio.post(
      ApiConfig.registerUrl,
      data: {'name': name, 'email': email, 'password': password},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  // Update user by ID
  static Future<Response> updateUser({
    required String id,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    return await _dio.put(
      ApiConfig.userUrl(id),
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  // Get user by ID
  static Future<Response> getUserById({
    required String id,
    required String token,
  }) async {
    return await _dio.get(
      ApiConfig.userUrl(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Get user by email
  static Future<Response> getUserByEmail({
    required String email,
    required String token,
  }) async {
    return await _dio.get(
      ApiConfig.userByEmailUrl(email),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Get users with pagination and search
  static Future<Response> getUsers({
    int limit = 10,
    int page = 1,
    String search = '',
    required String token,
  }) async {
    final queryParams = {
      'limit': limit,
      'page': page,
      if (search.isNotEmpty) 'search': search,
    };
    return await _dio.get(
      ApiConfig.usersUrl,
      queryParameters: queryParams,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Delete user by ID
  static Future<Response> deleteUser({
    required String id,
    required String token,
  }) async {
    return await _dio.delete(
      ApiConfig.userUrl(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
