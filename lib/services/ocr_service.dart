import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class OcrService {
  /// Process receipt image using OCR to extract expense information
  static Future<Map<String, dynamic>> processReceipt(File imageFile) async {
    try {
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Send to OCR API endpoint
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/ocr/process-receipt'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
          'filename': imageFile.path.split('/').last,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['message'] ?? 'Failed to process receipt',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Mock OCR processing for development/testing
  static Future<Map<String, dynamic>> mockProcessReceipt(File imageFile) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Return mock data
    return {
      'success': true,
      'data': {
        'title': 'Grocery Shopping',
        'amount': 45.67,
        'category': 'Food',
        'description': 'Receipt from grocery store',
        'date': DateTime.now().toIso8601String(),
        'merchant': 'Walmart',
        'confidence': 0.85,
      },
    };
  }

  /// Extract text from image using OCR
  static Future<Map<String, dynamic>> extractText(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/ocr/extract-text'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'text': data['text'],
          'confidence': data['confidence'],
        };
      } else {
        return {'success': false, 'error': 'Failed to extract text'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Parse extracted text to identify expense information
  static Map<String, dynamic> parseExpenseFromText(String text) {
    // Simple parsing logic - in a real app, you'd use more sophisticated NLP
    final lines = text.split('\n');
    String title = '';
    double amount = 0.0;
    String category = 'Other';
    String description = '';

    // Look for amount (common patterns)
    final amountPattern = RegExp(r'\$?\d+\.?\d*');
    for (final line in lines) {
      final matches = amountPattern.allMatches(line);
      for (final match in matches) {
        final potentialAmount = double.tryParse(
          match.group(0)!.replaceAll('\$', ''),
        );
        if (potentialAmount != null && potentialAmount > amount) {
          amount = potentialAmount;
        }
      }
    }

    // Look for merchant/store name (usually in first few lines)
    if (lines.isNotEmpty) {
      title = lines.first.trim();
      if (title.length > 50) {
        title = title.substring(0, 50);
      }
    }

    // Categorize based on keywords
    final lowerText = text.toLowerCase();
    if (lowerText.contains('grocery') ||
        lowerText.contains('food') ||
        lowerText.contains('restaurant') ||
        lowerText.contains('cafe')) {
      category = 'Food';
    } else if (lowerText.contains('gas') ||
        lowerText.contains('fuel') ||
        lowerText.contains('uber') ||
        lowerText.contains('taxi')) {
      category = 'Transport';
    } else if (lowerText.contains('amazon') ||
        lowerText.contains('walmart') ||
        lowerText.contains('target') ||
        lowerText.contains('shopping')) {
      category = 'Shopping';
    } else if (lowerText.contains('netflix') ||
        lowerText.contains('spotify') ||
        lowerText.contains('movie') ||
        lowerText.contains('entertainment')) {
      category = 'Entertainment';
    } else if (lowerText.contains('electric') ||
        lowerText.contains('water') ||
        lowerText.contains('internet') ||
        lowerText.contains('phone')) {
      category = 'Bills';
    }

    return {
      'title': title.isNotEmpty ? title : 'Receipt',
      'amount': amount,
      'category': category,
      'description': 'Processed from receipt image',
      'confidence': 0.7,
    };
  }
}
