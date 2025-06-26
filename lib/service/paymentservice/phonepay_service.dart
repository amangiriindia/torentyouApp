import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../../constant/env_config.dart';
import '../../constant/phone_pay_config.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PaymentService {
  static bool _isInitialized = false;

  /// Initializes the PhonePe SDK
  static Future<bool> initializePhonePe() async {
    try {


      bool result = await PhonePePaymentSdk.init(
        'SANDBOX',
        'KUAT',
        "KUAT",
        true, // Enable logging
      );

      _isInitialized = result;
      print("PhonePe SDK initialized: $result");
      return result;
    } catch (e) {
      print("Error initializing PhonePe SDK: $e");
      _isInitialized = false;
      return false;
    }
  }

  /// Generates a unique transaction ID
  static String generateTransactionId() {
    return "T${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(10000)}";
  }

  /// Generates checksum for the transaction
  static String generateChecksum(String payload, String endpoint) {
    final key = "$payload$endpoint${PhonePeConfig.apiKey}";
    final bytes = utf8.encode(key);
    final hash = sha256.convert(bytes);
    return "${hash.toString()}###${PhonePeConfig.apiKeyIndex}";
  }

  /// Checks transaction status via API
  static Future<Map<String, dynamic>> checkTransactionStatus(String transactionId) async {
    try {
      final endpoint = "/pg/v1/status/${PhonePeConfig.merchantId}/$transactionId";
      final checksum = generateChecksum("", endpoint);

      final response = await http.get(
        Uri.parse("${PhonePeConfig.hostUrl}$endpoint"),
        headers: {
          "Content-Type": "application/json",
          "X-VERIFY": checksum,
          "X-MERCHANT-ID": PhonePeConfig.merchantId,
        },
      );

      print("Status check response: ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      print("Status check error: $e");
      return {"success": false, "error": e.toString()};
    }
  }

  /// Starts a payment transaction
  static Future<Map<String, dynamic>> startPayment({
    required double amount,
    required String userId,
    String? mobileNumber,
  }) async {
    try {
      if (!_isInitialized) {
        final initResult = await initializePhonePe();
        if (!initResult) {
          return {'success': false, 'error': 'PhonePe SDK initialization failed'};
        }
      }

      final transactionId = generateTransactionId();
      final amountInPaise = (amount * 100).toInt();

      final paymentRequest = {
        "merchantId": 'M22Z0YGPLTMPGUAT',
        "merchantTransactionId": transactionId,
        "merchantUserId": userId,
        "amount": amountInPaise,
        "callbackUrl": EnvConfig.CALLBACK_URL,
        "mobileNumber": mobileNumber ?? "9999999999",
        "paymentInstrument": {"type": "PAY_PAGE"}
      };

      final payloadJson = jsonEncode(paymentRequest);
      final payload = base64.encode(utf8.encode(payloadJson));

      print("Payload JSON: $payloadJson");
      print("Base64 Payload: $payload");

      final endpoint = "/pg/v1/pay";
      final checksum = generateChecksum(payload, endpoint);

      final response = await PhonePePaymentSdk.startTransaction(
        'ewogICJtZXJjaGFudElkIjogIk0yMlowWUdQTFRNUEdVQVQiLAogICJtZXJjaGFudFRyYW5zYWN0aW9uSWQiOiAiTVQ3ODUwNTkwMDY4MTg4MTA0IiwKICAibWVyY2hhbnRVc2VySWQiOiAiTVVJRDEyMyIsCiAgImFtb3VudCI6IDEwMDAwLAogICJjYWxsYmFja1VybCI6ICJodHRwczovL3dlYmhvb2suc2l0ZS9jYWxsYmFjay11cmwiLAogICJtb2JpbGVOdW1iZXIiOiAiOTk5OTk5OTk5OSIsCiAgInBheW1lbnRJbnN0cnVtZW50IjogewogICAgInR5cGUiOiAiUEFZX1BBR0UiCiAgfQp9',
        "",
        'd02a119170e37ceee3ea2fac19f41c735ca8e4aae7a3c4444592b15af19ab486###1',
        ""
      );

      print("Payment response: $response");

      if (response == null || response['status'] == 'PENDING') {
        final statusResponse = await checkTransactionStatus(transactionId);
        return {
          'success': statusResponse['success'] == true,
          'transactionId': transactionId,
          'response': statusResponse,
          'error': statusResponse['message'] ?? 'Transaction status check failed',
        };
      }

      return {
        'success': response['status'] == 'SUCCESS',
        'transactionId': transactionId,
        'response': response,
        'error': response['error'] ?? null,
      };
    } catch (e) {
      print("Payment error: $e");
      return {
        'success': false,
        'transactionId': generateTransactionId(),
        'error': e.toString(),
      };
    }
  }
}
