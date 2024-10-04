import 'package:crypto/crypto.dart';
import 'dart:convert';

String _generateSignature(String payload, String secretKey) {
  var key = utf8.encode(secretKey);
  var bytes = utf8.encode(payload);

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  Digest digest = hmacSha256.convert(bytes);

  return digest.toString();
}
