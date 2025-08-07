import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/user_constant.dart';
import '../consts.dart';

class UserService {
  // Base URL for API calls
  static const String baseUrl = AppConstant.API_URL;

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String contact,
    required String about,
  }) async {
    try {

      print(userId);
      print(name);
      print(email);
      print(contact);
      var url = Uri.parse('${baseUrl}api/v1/seller/user-update-profile');

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": userId,
          "name": name,
          "email": email,
          "contact": contact,
          "about": about,
        }),
      );
       print(response.body);
       print(response.statusCode);
      var responseData = jsonDecode(response.body);
      // Save user data
      await UserConstant.saveUserData(responseData['data']);
      return {
        'success': response.statusCode == 200 && responseData['success'],
        'message': responseData['message'] ?? 'Unknown error occurred',
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'data': null,
        'statusCode': 0,
      };
    }
  }

  // Change user password
  static Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String newPassword,
  }) async {
    try {
      var url = Uri.parse('${baseUrl}api/v1/seller/user-change-password');

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": userId,
          "password": newPassword,
        }),
      );

      var responseData = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200 && responseData['success'],
        'message': responseData['message'] ?? 'Unknown error occurred',
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'data': null,
        'statusCode': 0,
      };
    }
  }

  // Get user profile (if needed)
  static Future<Map<String, dynamic>> getUserProfile({
    required int userId,
  }) async {
    try {
      var url = Uri.parse('${baseUrl}api/v1/seller/user-profile/$userId');

      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      var responseData = jsonDecode(response.body);

      return {
        'success': response.statusCode == 200 && responseData['success'],
        'message': responseData['message'] ?? 'Unknown error occurred',
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'data': null,
        'statusCode': 0,
      };
    }
  }
}