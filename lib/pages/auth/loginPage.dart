import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:try_test/pages/auth/login_otp_verified.dart';
import '../../service/api_service.dart';
import '../../consts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneNumberController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _sendOtp() async {
    final contact = _phoneNumberController.text;

    if (contact.isEmpty || contact.length != 10) {
      Fluttertoast.showToast(
        msg: "Please enter a valid 10-digit phone number",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final result = await _apiService.loginSendOtp(contact);

    if (result['success']) {
      final otpValue = result['otp'];
      final userId = result['userId'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            contact: contact,
            otpValue: otpValue,
            userId: userId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.primaryTextColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/logo.png',
                height: 100,
              ),

              const SizedBox(height: 20),

              // Divider with "login or signup" text
              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.white70,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Login or Signup",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Phone Number Input Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "+91",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _phoneNumberController,
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

              const SizedBox(height: 40),

              // Send OTP Button
              GestureDetector(
                onTap: () => _sendOtp(),
                child: Container(
                   width: double.infinity,
                height: 50,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryTextColor,
                        AppColors.primaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: const Text(
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
      ),
    );
  }
}
