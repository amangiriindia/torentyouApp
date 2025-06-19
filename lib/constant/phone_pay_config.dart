import 'dart:io';

import 'env_config.dart';

class PhonePeConfig {
  // Test Credentials
  static const String testMerchantId = "PGTESTPAYUAT";
  static const String testApiKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  static const int testApiKeyIndex = 1;
  static const String testHostUrl = "https://api-preprod.phonepe.com/apis/hermes";

  // Production Credentials
  static const String prodMerchantId = "M22Z0YGPLTMPG";
  static const String prodApiKey = "YOUR_PRODUCTION_API_KEY"; // Replace with actual key
  static const int prodApiKeyIndex = 1;
  static const String prodHostUrl = "https://api.phonepe.com/apis/hermes";

  // Current environment settings
  static const bool isProduction = false; // Set to true for production

  // Dynamic getters based on environment
  static String get merchantId => isProduction ? prodMerchantId : testMerchantId;
  static String get apiKey => isProduction ? prodApiKey : testApiKey;
  static int get apiKeyIndex => isProduction ? prodApiKeyIndex : testApiKeyIndex;
  static String get hostUrl => isProduction ? prodHostUrl : testHostUrl;
  static String get environment => isProduction ? "PRODUCTION" : "SANDBOX";
  static String get appSchema => Platform.isAndroid ? "com.example.app" : "yourappscheme://";
  static String get flowId => "FLOW_${DateTime.now().millisecondsSinceEpoch}"; // Unique flow ID
}