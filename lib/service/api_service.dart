import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:try_test/constant/user_constant.dart';
import 'package:try_test/pageutills/myAdsReviewByProduct.dart';
import '../../consts.dart';

class ApiService {
  Future<void> sendOtp(String contact) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstant.API_URL}api/v1/seller/login-otp-send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contact': contact}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        Fluttertoast.showToast(
          msg: "OTP Sent Successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to send OTP",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<Map<String, dynamic>> loginSendOtp(String contact) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstant.API_URL}api/v1/seller/login-otp-send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contact': contact}),
      );
      print(response.statusCode);
      print(response.body);
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        Fluttertoast.showToast(
          msg: "OTP Sent Successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return {
          'success': true,
          'otp': responseData['data']['otp'].toString(),
          'userId': responseData['data']['id'],
        };
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return {'success': false};
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to send OTP",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return {'success': false};
    }
  }

  Future<bool> verifyOtp(int userId, String contact, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstant.API_URL}api/v1/seller/login-otp-verfied'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': userId,
          'contact': contact,
          'otp': otp,
        }),
      );

      print(response.body);
      print(response.statusCode);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        // Save user data to UserConstant
        await UserConstant.saveUserData(responseData['data']);

        Fluttertoast.showToast(
          msg: "OTP Verified Successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        return true; // Login successful
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        return false; // Login failed
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error verifying OTP",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  // Function to fetch product details
  Future<Map<String, dynamic>?> fetchProductDetails(int productId) async {
    final url =
        '${AppConstant.API_URL}api/v1/product/single-product/$productId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            'Failed to fetch product details. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Function to create a chat room
  Future<bool> createChatRoom(Map<String, dynamic> requestData) async {
    const String apiUrl = '${AppConstant.API_URL}api/v1/chat/create-chat-room';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 201) {
        print('Chat room created successfully.');
        return true;
      } else {
        print(
            'Failed to create chat room. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  // Function to fetch the receiver's email by seller ID
  Future<String?> getReceiverEmail(int reciverId) async {
    final url = '${AppConstant.API_URL}api/v1/seller/single-seller/$reciverId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['email'];
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  //function for get my ads
  Future<List<dynamic>> fetchMyAds(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${AppConstant.API_URL}api/v1/product/user-myads-all-product'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"seller_id": userId}),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['results'];
        } else {
          throw Exception('Failed to fetch ads: ${data['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ads: $e');
    }
  }

  // Get Subscription Plan
   static Future<List<Map<String, dynamic>>> fetchSubscriptions() async {
    final url = '${AppConstant.API_URL}api/v1/subscription/all-subscription';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['results']);
        } else {
          throw Exception('Failed to load subscriptions');
        }
      } else {
        throw Exception('Network error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subscriptions: $e');
    }
  }


   Future<List<Map<String, dynamic>>> fetchUserSubscriptions(int userId) async {
    final String url = '${AppConstant.API_URL}api/v1/usersubscription/single-user-subscription/$userId';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map<Map<String, dynamic>>((data) {
          final jsonData = json.decode(data['json_data']);
          return {
            'planName': jsonData['description'] ?? 'N/A',
            'price': '₹${data['price']} /-',
            'duration': '${jsonData['duration']} Months',
            'totalAds': data['total_ads'].toString(),
            'usedAds': data['used_ads'].toString(),
            'availableAds': data['balance_ads'].toString(),
            'startDate': data['subscription_date'],
            'expiry': data['expiry_date'],
            'status': data['status'] == 'Approved' ? 'Active' : 'Expired',
          };
        }).toList();
      } else {
        throw Exception('Failed to load subscriptions');
      }
    } catch (e) {
      throw Exception('Error fetching subscriptions: $e');
    }
  }

// for get prodct review 
 Future<List<Review>> fetchReviews(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstant.API_URL}api/v1/review/all-product-review/$productId'),
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          return (data['data'] as List).map((item) {
            return Review(
              rating: item['rating'],
              comment: item['comment'],
              userName: item['name'],
              mobile: item['email'],
              date: item['date_time'],
            );
          }).toList();
        } else {
          throw Exception('Failed to load reviews');
        }
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  }



