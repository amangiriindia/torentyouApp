import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:try_test/constant/user_constant.dart';
import 'package:try_test/pages/mainPage.dart';

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
}
