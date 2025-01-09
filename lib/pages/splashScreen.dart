import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainPage.dart';
import 'onBoardingScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt('userId');
print(userId);
    Future.delayed(const Duration(seconds: 3), () {
      if (userId == null) {
        // Navigate to HomePage if userId exists
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      } else {
        // Navigate to OnBoardingPage if userId is null
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OnBoardingScreen(
              onDone: () {},
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo.png', width: 200, height: 350), // Adjust size as needed
      ),
    );
  }
}
