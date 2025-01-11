import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final enteredOtp = _otpControllers.map((controller) => controller.text).join();

  if (enteredOtp.length != 6) {
    Fluttertoast.showToast(
      msg: "Please enter a valid 6-digit OTP",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    return;
  }

  final isVerified = await _apiService.verifyOtp(widget.userId, widget.contact, enteredOtp);

  if (isVerified) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
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
              // Header Text
              Text(
                "Verify OTP",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Enter the OTP sent to +91 ${widget.contact}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 30),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 50,
                    height: 60,
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
                    child: TextField(
                      controller: _otpControllers[index],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.length == 1)
                          FocusScope.of(context).nextFocus();
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Resend Timer and Button
              Text(
                "Resend OTP in $_timeRemaining seconds",
                style: TextStyle(
                  color: _isResendEnabled ? Colors.green : Colors.white70,
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

              // Verify Button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryTextColor
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Verify OTP",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
