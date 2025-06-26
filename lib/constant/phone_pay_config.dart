import 'dart:io';

class PhonePeConfig {
  static const String testMerchantId = "M22Z0YGPLTMPGUAT";
  static const String testApiKey = "5abca847-85df-4037-b419-9a9f10091a46";
  static const int testApiKeyIndex = 1;
  static const String testHostUrl = "https://api-preprod.phonepe.com/apis/hermes";

  static const String prodMerchantId = "M22Z0YGPLTMPG";
  static const String prodApiKey = "0e7888a6-5615-42d2-958c-34b55cdf1e93";
  static const int prodApiKeyIndex = 1;
  static const String prodHostUrl = "https://api.phonepe.com/apis/hermes";

  static const bool isProduction = false;

  static String get merchantId => isProduction ? prodMerchantId : testMerchantId;
  static String get apiKey => isProduction ? prodApiKey : testApiKey;
  static int get apiKeyIndex => isProduction ? prodApiKeyIndex : testApiKeyIndex;
  static String get hostUrl => isProduction ? prodHostUrl : testHostUrl;
  static String get environment => isProduction ? "PRODUCTION" : "UAT";
  static String get appSchema => Platform.isAndroid ? "com.amzsoft.torentyou" : "yourappscheme://";
  static String get flowId => "FLOW_${DateTime.now().millisecondsSinceEpoch}";
}


// MerchantId: M22Z0YGPLTMPGUAT
// "saltKey": "5abca847-85df-4037-b419-9a9f10091a46",
// "saltIndex": 1