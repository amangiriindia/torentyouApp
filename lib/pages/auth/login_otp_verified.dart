import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../consts.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../mainPage.dart';

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
  final TextEditingController _otpController = TextEditingController();
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _timeRemaining = 60;
  bool _isResendEnabled = false;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _otpController.addListener(_onOtpChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged() {
    setState(() {});
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

  Future<void> _checkUserProfileAndNavigate() async {
    try {
      // Get user profile to check if name is null or empty
      final profileResponse = await UserService.getUserProfile(userId: widget.userId);

      if (profileResponse['success']) {
        final userData = profileResponse['data']['data'];
        final String? userName = userData['name'];

        // Check if name is null or empty
        if (userName == null || userName.trim().isEmpty) {
          // Show profile completion popup
          _showProfileCompletionDialog();
        } else {
          // Navigate to main screen directly
          _navigateToMainScreen();
        }
      } else {
        // If profile fetch fails, show profile completion dialog as fallback
        _showProfileCompletionDialog();
      }
    } catch (e) {
      print('Error checking profile: $e');
      // Show profile completion dialog as fallback
      _showProfileCompletionDialog();
    }
  }

  void _showProfileCompletionDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isUpdatingProfile = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Please provide your name and email to continue',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isUpdatingProfile ? null : () {
                    // Skip button - navigate to main screen without updating profile
                    Navigator.of(context).pop();
                    _navigateToMainScreen();
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: isUpdatingProfile ? null : () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isUpdatingProfile = true;
                      });

                      try {
                        // Update profile
                        final result = await UserService.updateProfile(
                          userId: widget.userId,
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          contact: widget.contact,
                          about: 'User', // Empty about for now
                        );

                        if (result['success']) {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: "Profile updated successfully",
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                          _navigateToMainScreen();
                        } else {
                          Fluttertoast.showToast(
                            msg: result['message'] ?? "Failed to update profile",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: "Error updating profile: ${e.toString()}",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      } finally {
                        setState(() {
                          isUpdatingProfile = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: isUpdatingProfile
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Update Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _navigateToMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    final enteredOtp = _otpController.text;

    if (enteredOtp.length != 6) {
      Fluttertoast.showToast(
        msg: "Please enter a valid 6-digit OTP",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final isVerified = await _apiService.verifyOtp(widget.userId, widget.contact, enteredOtp);

    setState(() {
      _isLoading = false;
    });

    if (isVerified) {
      // After OTP verification, check profile and navigate accordingly
      _checkUserProfileAndNavigate();
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
        padding: EdgeInsets.zero,
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
                child: Stack(
                  children: [
                    // Invisible TextField that handles all input
                    Positioned.fill(
                      child: TextField(
                        controller: _otpController,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.transparent),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        cursorColor: Colors.transparent,
                        showCursor: false,
                        autofocus: true,
                      ),
                    ),
                    // Visual OTP boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        String displayText = '';
                        if (index < _otpController.text.length) {
                          displayText = _otpController.text[index];
                        }

                        return Container(
                          width: 50,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              displayText,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
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