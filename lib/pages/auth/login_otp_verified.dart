import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:try_test/pages/mainPage.dart';
import 'dart:async';
import '../../consts.dart';
import '../../service/api_service.dart';

class OTPScreen extends StatefulWidget {
  final String contact;
  final String otpValue;
  final int userId;

  const OTPScreen({
    super.key,
    required this.contact,
    required this.otpValue,
    required this.userId,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  Timer? _timer;
  int _timeRemaining = 60;
  bool _isResendEnabled = false;
  bool _isLoading = false; // Add this line
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() => _timeRemaining = 60);
    _isResendEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() => _timeRemaining--);
      } else {
        timer.cancel();
        setState(() => _isResendEnabled = true);
      }
    });
  }

  Future<void> _sendOtp() async {
    await _apiService.sendOtp(widget.contact);
    _startTimer();
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true; // Start loading when OTP verification starts
    });

    final enteredOtp = _otpControllers.map((controller) => controller.text).join();

    if (enteredOtp.length != 6) {
      Fluttertoast.showToast(
        msg: "Please enter a valid 6-digit OTP",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        _isLoading = false; // Stop loading if OTP is invalid
      });
      return;
    }

    final isVerified = await _apiService.verifyOtp(widget.userId, widget.contact, enteredOtp);

    setState(() {
      _isLoading = false; // Stop loading once verification is done
    });

    if (isVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Invalid OTP",
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
        margin: const EdgeInsets.only(bottom: 0),
        padding: EdgeInsets.zero, // No padding
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),

              // Header Text
              const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Enter the OTP sent to +91 ${widget.contact}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // OTP Input Fields
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: _otpControllers[index],
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Resend Timer
              Text(
                "Resend OTP in $_timeRemaining seconds",
                style: TextStyle(
                  color: _isResendEnabled ? Colors.green : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _isResendEnabled ? _sendOtp : null,
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: _isResendEnabled ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Verify OTP Button with Loading State
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: _isLoading ? null : _verifyOtp,
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
                              "Verify OTP",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 110),  

              // Animation Container
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
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/anim/anim_1.json',
                      height: MediaQuery.of(context).size.height * 0.4,
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

  