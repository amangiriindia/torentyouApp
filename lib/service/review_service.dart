
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewService {
  static const String baseUrl = 'https://trytest-xcqt.onrender.com/api/v1/review';

  // Submit review to API
  Future<Map<String, dynamic>?> submitReview({
    required String productId,
    required String rating,
    required String name,
    required String email,
    required String comment,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/create-review');
      
      final requestBody = {
        "product_id": productId,
        "rating": rating,
        "name": name,
        "email": email,
        "comment": comment,
        "status": "active", // Default status
        "date_time": DateTime.now().toIso8601String(),
      };

      print('Submitting review: $requestBody');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in submitReview: $e');
      return null;
    }
  }

  // Get reviews for a product (placeholder for future implementation)
  Future<List<Map<String, dynamic>>?> getProductReviews(String productId) async {
    try {
      // TODO: Implement when get reviews API is available
      // final url = Uri.parse('$baseUrl/get-reviews/$productId');
      // final response = await http.get(url);
      // ... implementation
      return null;
    } catch (e) {
      print('Exception in getProductReviews: $e');
      return null;
    }
  }
}