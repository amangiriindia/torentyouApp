import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import '../../service/api_service.dart';
import '../../consts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneNumberController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });

    final contact = _phoneNumberController.text;

    if (contact.isEmpty || contact.length != 10) {
      Fluttertoast.showToast(
        msg: "Please enter a valid 10-digit phone number",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final result = await _apiService.loginSendOtp(contact);

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      final otpValue = result['otp'];
      final userId = result['userId'];

      // Navigate to the OTP verification screen
    } else {
      Fluttertoast.showToast(
        msg: "Failed to send OTP. Please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gradient background with Lottie animation
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryTextColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/anim/anim_2.json',
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              Image.asset(
                "assets/logo.png",
                width: 200,
                height: 100,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 10),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    // Phone Number Input Field
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _phoneFocusNode.hasFocus
                                ? AppColors.primaryColor
                                : AppColors
                                    .primaryTextColor, // Black border when not focused
                            width: _phoneFocusNode.hasFocus
                                ? 2
                                : 1, // Thicker border when focused
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.phone,
                                color: AppColors.primaryColor),
                            const SizedBox(width: 10),
                            const Text(
                              "+91",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _phoneNumberController,
                                focusNode: _phoneFocusNode,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontSize: 16),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter your phone number",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Send OTP Button
                    GestureDetector(
                      onTap: _isLoading ? null : _sendOtp,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryTextColor,
                              AppColors.primaryColor
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Send OTP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
