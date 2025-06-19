import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import '../../constant/env_config.dart';
import '../../constant/phone_pay_config.dart';


class PaymentService {
  static bool _isInitialized = false;

  /// Initializes the PhonePe SDK
  static Future<bool> initializePhonePe() async {
    try {
      if (_isInitialized) {
        print("PhonePe SDK already initialized");
        return true;
      }

      bool result = await PhonePePaymentSdk.init(
        PhonePeConfig.environment, // "UAT" for testing
        PhonePeConfig.merchantId,
        PhonePeConfig.flowId, // Unique flow ID
        true, // Enable logging for debugging
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

  /// Starts a payment transaction
  static Future<Map<String, dynamic>> startPayment({
    required double amount,
    required String userId,
    String? mobileNumber,
  }) async {
    try {
      // Ensure SDK is initialized
      if (!_isInitialized) {
        final initResult = await initializePhonePe();
        if (!initResult) {
          return {
            'success': false,
            'error': 'PhonePe SDK initialization failed',
          };
        }
      }

      final transactionId = generateTransactionId();
      final amountInPaise = (amount * 100).toInt();

      // Construct payment request for PAY_PAGE
      final paymentRequest = {
        "merchantId": PhonePeConfig.merchantId,
        "merchantTransactionId": transactionId,
        "merchantUserId": userId,
        "amount": amountInPaise,
        "redirectUrl": EnvConfig.REDIRECT_URL, // e.g., "https://webhook.site/redirect-url"
        "redirectMode": "REDIRECT", // Correct for PAY_PAGE
        "callbackUrl": EnvConfig.CALLBACK_URL, // e.g., "https://webhook.site/callback-url"
        "mobileNumber": mobileNumber ?? "",
        "paymentInstrument": {"type": "PAY_PAGE"}
      };

      // Encode payload to base64
      final payload = base64.encode(utf8.encode(jsonEncode(paymentRequest)));
      const endpoint = "/pg/v1/pay";

      // Start transaction (assuming your SDK uses startTransaction)
      final response = await PhonePePaymentSdk.startTransaction(
         payload,
         PhonePeConfig.appSchema,
      );

      print("Payment response: $response");

      if (response == null) {
        return {
          'success': false,
          'transactionId': transactionId,
          'error': 'Null response from PhonePe SDK',
        };
      }

      return {
        'success': response['status'] == 'SUCCESS',
        'transactionId': transactionId,
        'response': response,
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