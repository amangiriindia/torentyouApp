import 'dart:convert';
import 'package:http/http.dart' as http;

class PhonePeService {
  final String baseUrl;
  final String apiKey;
  final int apiKeyIndex;

  PhonePeService({required this.baseUrl, required this.apiKey, required this.apiKeyIndex});

  Future<void> initiateTransaction({
    required String merchantId,
    required String transactionId,
    required int amount,
    required String currency,
    required String redirectUrl,
  }) async {
    try {
      final String url = '$baseUrl/v1/transaction/initiate';

      Map<String, dynamic> body = {
        "merchantId": merchantId,
        "transactionId": transactionId,
        "amount": amount,
        "currency": currency,
        "redirectUrl": redirectUrl,
        // Add other required fields as per PhonePe's API documentation
      };

      final String payload = jsonEncode(body);

      final headers = {
        'Content-Type': 'application/json',
        'X-VERIFY': _generateSignature(payload), // Signature based on PhonePe requirements
        'X-MERCHANT-ID': merchantId,
        'X-API-KEY': apiKey,
        'X-API-KEY-INDEX': apiKeyIndex.toString(),
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: payload,
      );

      if (response.statusCode == 200) {
        // Handle success response
        print('Transaction initiated successfully.');
      } else {
        // Handle error response
        print('Failed to initiate transaction: ${response.body}');
      }
    } catch (e) {
      print('Error initiating transaction: $e');
    }
  }

  String _generateSignature(String payload) {
    // Implement the signature generation logic based on PhonePe's API documentation
    // Generally, this involves hashing the payload using your secret key.
    return '';  // Return the generated signature
  }
}
