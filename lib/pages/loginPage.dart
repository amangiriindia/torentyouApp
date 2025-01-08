import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts.dart';
import 'mainPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showOtpField = false;
  String? otpValue;
  int? userId;
  final _phoneNumberController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  bool _isOtpButtonDisabled = false;
  int _secondsRemaining = 0;
  Timer? _timer;

  Future<void> _sendOtp() async {
    final contact = _phoneNumberController.text;

    try {
      final response = await http.post(
        Uri.parse('${AppConstant.API_URL}api/v1/seller/login-otp-send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contact': contact}),
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        final data = responseData['data'];

        setState(() {
          _showOtpField = true;
          otpValue = data['otp'].toString();
          userId = data['id'];
          _startOtpTimer();
        });

        Fluttertoast.showToast(
          msg: "OTP Sent Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  void _startOtpTimer() {
    setState(() {
      _isOtpButtonDisabled = true;
      _secondsRemaining = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isOtpButtonDisabled = false;
        });
      }
    });
  }

  Future<void> _verifyOtp() async {
    final contact = _phoneNumberController.text;
    final enteredOtp = _otpControllers.map((controller) => controller.text).join();

    if (enteredOtp.length != 6) {
      Fluttertoast.showToast(
        msg: "Please enter a valid 6-digit OTP",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${AppConstant.API_URL}api/v1/seller/login-otp-verfied'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': userId,
          'contact': contact,
          'otp': enteredOtp,
        }),
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        Fluttertoast.showToast(
          msg: "OTP Verified Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        final userData = responseData['data'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userData['id']);
        await prefs.setString('name', userData['name'] ?? '');
        await prefs.setString('email', userData['email'] ?? '');
        await prefs.setString('contact', userData['contact']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error verifying OTP: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 100,
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: Divider(thickness: 1, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "login or signup",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Divider(thickness: 1, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Text("+91", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your phone number",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.primaryTextColor],
                ),
              ),
              child: ElevatedButton(
                onPressed: _isOtpButtonDisabled ? null : () async {
                  await _sendOtp();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isOtpButtonDisabled
                      ? "Resend OTP in $_secondsRemaining sec"
                      : "Send OTP",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            if (_showOtpField) ...[
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _otpControllers[index],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [AppColors.primaryTextColor, AppColors.primaryColor],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

