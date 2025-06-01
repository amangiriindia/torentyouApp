import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../components/Button.dart';
import '../consts.dart';
import 'auth/loginPage.dart';

class OnBoardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  const OnBoardingScreen({super.key, required this.onDone});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool showGetStartedButton = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.page == 3.0) { // Show button only on the 5th screen
        setState(() => showGetStartedButton = true);
      } else {
        setState(() => showGetStartedButton = false);
      }
    });
  }

  Future<void> requestPermissions() async {
    PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permission is required for better functionality.')),
      );
    }

    PermissionStatus notificationStatus =
        await Permission.notification.request();
    if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Notification permission is required for updates.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              _buildOnboardingPage(
                'Welcome To Rent You!',
                'assets/anim/anim_11.json',
                'Your gateway to hassle-free rentals.',
                isLocal: true,
              ),
              _buildOnboardingPage(
                'Connect with a Vast Network',
                'assets/anim/anim_7.json',
                'Discover endless rental opportunities around you.',
                isLocal: true,
              ),
              _buildOnboardingPage(
                'Explore Everywhere',
                'assets/anim/anim_8.json',
                'Find rentals in every corner, anytime, anywhere.',
                isLocal: true,
              ),
              _buildOnboardingPage(
                'Secure and Reliable Rentals',
                'assets/anim/anim_9.json',
                'Experience trusted and secure rental transactions.',
                isLocal: true,
              ),

            ],
          ),
          if (showGetStartedButton)
            Align(
              alignment: const Alignment(0, 0.75),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AnimatedOpacity(
                  opacity: showGetStartedButton ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: ButtonCustom(
                    callback: () async {
                      await requestPermissions();
                      widget.onDone();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    title: "Get Started",
                    gradient: const LinearGradient(colors: [
                      AppColors.primaryColor,
                      AppColors.primaryTextColor,
                    ]),
                  ),
                ),
              ),
            ),
          Container(
            alignment: const Alignment(0, 0.9),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: const JumpingDotEffect(
                activeDotColor: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
      String title, String? imagePath, String description,
      {bool isLocal = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLocal
              ? Lottie.asset(imagePath!,
                  height: 400, width: 800, fit: BoxFit.contain)
              : Lottie.network(imagePath!,
                  height: 400, width: 800, fit: BoxFit.contain),
          Text(title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
