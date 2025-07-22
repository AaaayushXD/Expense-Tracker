import 'package:dio/dio.dart';
import 'package:expense_tracker/services/api_service.dart';

class UploadApiService {
  static final Dio _dio = Dio();

  static const String _uploadUrl =
      'https://docapi.crequity.ai/document/upload?includeBase64=false';

  static Future<Response> uploadDocument(FormData formData) async {
    try {
      final token = await ApiService.getStoredToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      final response = await _dio.post(
        _uploadUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print("RESPONSE FROM UPLOAD: ${response.data}");
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
