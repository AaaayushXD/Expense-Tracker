import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import '../../config/api_config.dart';
import '../api_service.dart';
import '../upload/upload_api_service.dart';

class DocumentApiService {
  static final Dio _dio = Dio();

  // Add a new document
  static Future<Response> addDocument({
    required String userId,
    required String documentType,
    required String s3Url,
    required String token,
  }) async {
    return await _dio.post(
      ApiConfig.addDocumentUrl,
      data: {'userId': userId, 'documentType': documentType, 's3Url': s3Url},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  // Get document by ID
  static Future<Response> getDocumentById({
    required String id,
    required String token,
  }) async {
    return await _dio.get(
      ApiConfig.documentByIdUrl(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Get documents by user ID with pagination
  static Future<Response> getDocumentsByUserId({
    required String userId,
    int page = 1,
    int limit = 10,
    required String token,
  }) async {
    final queryParams = {'page': page, 'limit': limit};
    return await _dio.get(
      ApiConfig.documentsByUserIdUrl(userId),
      queryParameters: queryParams,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// A high-level method to handle the full document upload flow.
  /// It first uploads the file to get an S3 URL, then saves the document
  /// metadata to the application's database.
  ///
  /// [imagePath] is the local path to the image file.
  /// [documentType] is a string representing the type of document (e.g., 'receipt').
  static Future<Response> uploadAndCreateDocument({
    required String imagePath,
    required String documentType,
  }) async {
    // 1. Get user ID and token from storage.
    final userId = await ApiService.getStoredUserId();
    final token = await ApiService.getStoredToken();

    if (userId == null || token == null) {
      throw Exception('User is not authenticated. Please log in again.');
    }

    // 2. Upload the image file to the document processing service.
    final fileName = p.basename(imagePath);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imagePath, filename: fileName),
    });
    print('Uploading document: $fileName');

    final uploadResponse = await UploadApiService.uploadDocument(formData);
    print("Upload Response: ${uploadResponse.data}");

    // 3. Extract the S3 URL from the response.
    // Note: The response structure is assumed. You might need to adjust the key.
    final s3Url = uploadResponse.data['s3Url'] as String?;

    if (s3Url == null || s3Url.isEmpty) {
      throw Exception('Could not retrieve S3 URL from upload response.');
    }

    // 4. Add the document metadata to the database.
    return addDocument(
      userId: userId,
      documentType: documentType,
      s3Url: s3Url,
      token: token,
    );
  }
}
