import 'package:dio/dio.dart';
import '../../config/api_config.dart';

class OcrApiService {
  static final Dio _dio = Dio();

  // Send document to OCR engine
  static Future<Response> sendToOcrEngine({
    required String url,
    required String docType,
    required String docId,
    required String userId,
    required String token,
  }) async {
    return await _dio.post(
      ApiConfig.ocrEngineUrl,
      data: {
        'url': url,
        'doc_type': docType,
        'doc_id': docId,
        'user_id': userId,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  // Get OCR data by job ID
  static Future<Response> getOCRByJobId({
    required String jobId,
    required String token,
  }) async {
    return await _dio.get(
      ApiConfig.ocrByJobIdUrl(jobId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Update OCR extracted fields by job ID
  static Future<Response> updateOCRExtractedFields({
    required String jobId,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    return await _dio.put(
      ApiConfig.ocrByJobIdUrl(jobId),
      data: {'data': data},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
