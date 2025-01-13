import 'package:flutter/material.dart';
import 'package:try_test/constant/user_constant.dart';
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
    print(UserConstant.USER_ID);
    print(UserConstant.NAME);
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    print(UserConstant.USER_ID);
    print(UserConstant.NAME);
    Future.delayed(const Duration(seconds: 3), () {
      if (UserConstant.USER_ID != null && UserConstant.USER_ID != 0) {
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
        child: Image.asset('assets/logo.png',
            width: 200, height: 350), // Adjust size as needed
      ),
    );
  }
}
