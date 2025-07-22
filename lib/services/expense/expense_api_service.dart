import 'package:dio/dio.dart';
import '../../config/api_config.dart';

class Expense {
  final String category;
  final double amount;
  final String description;
  final DateTime date;

  Expense({
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
      };
}

class Revenue {
  final String category;
  final double amount;
  final String description;
  final DateTime date;

  Revenue({
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'amount': amount,
        'description': description,
        'date': date.toIso8601String(),
      };
}

class ExpenseApiService {
  static final Dio _dio = Dio();

  // Add a monthly transaction
  static Future<Response> addMonthlyTransaction({
    required String userId,
    String? documentId,
    required Expense expense,
    required Revenue revenue,
    required DateTime month,
    required String processedBy,
    required String uploadedBy,
    required String token,
  }) async {
    return await _dio.post(
      ApiConfig.addMonthlyTransactionUrl,
      data: {
        'userId': userId,
        if (documentId != null) 'documentId': documentId,
        'expense': expense.toJson(),
        'revenue': revenue.toJson(),
        'month': month.toIso8601String(),
        'processedBy': processedBy,
        'uploadedBy': uploadedBy,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  // Get monthly transactions by user ID with pagination
  static Future<Response> getMonthlyTransactionsByUserId({
    required String userId,
    int page = 1,
    int limit = 10,
    required String token,
  }) async {
    final queryParams = {'page': page, 'limit': limit};
    return await _dio.get(
      ApiConfig.monthlyTransactionsByUserIdUrl(userId),
      queryParameters: queryParams,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Get monthly transaction by ID
  static Future<Response> getMonthlyTransactionById({
    required String id,
    required String token,
  }) async {
    return await _dio.get(
      ApiConfig.monthlyTransactionByIdUrl(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Update monthly transaction by ID
  static Future<Response> updateMonthlyTransaction({
    required String id,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    return await _dio.put(
      ApiConfig.monthlyTransactionByIdUrl(id),
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
