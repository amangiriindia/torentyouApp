import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:try_app/consts.dart';
import 'package:try_app/pages/auth/loginPage.dart';

class WithoutLoginWidget extends StatelessWidget {
  const WithoutLoginWidget({Key? key}) : super(key: key);

  void _navigateToLogin(BuildContext context) {
    // Navigate to login page
    // Replace 'LoginPage()' with your actual login page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(), // Your login page
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.white,
            Colors.blue.shade50,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lottie Animation
            Container(
              height: 250,
              width: 250,
              child: Lottie.asset(
                'assets/anim/anim_8.json', // Add your Lottie file path
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
              ),
            ),

            const SizedBox(height: 30),

          // Title
const Text(
  'Login to explore TRY',
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
  textAlign: TextAlign.center,
),

const SizedBox(height: 15),

// Subtitle
const Text(
  'Please log in to access all features and connect with others.',
  style: TextStyle(
    fontSize: 16,
    color: Colors.grey,
    height: 1.4,
  ),
  textAlign: TextAlign.center,
),


            const SizedBox(height: 50),

            // Login Button
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryTextColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  _navigateToLogin(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),


        

            // Additional Info
           
          ],
        ),
      ),
    );
  }
}
