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
      if (_controller.page == 2.0) {
        // Page 3 index is 2
        setState(() => showGetStartedButton = true);
      } else {
        setState(() => showGetStartedButton = false);
      }
    });
  }

  Future<void> requestPermissions() async {
    // Request location permission
    PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
      // Handle location permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required for better functionality.')),
      );
    }

    // Request notification permission
    PermissionStatus notificationStatus = await Permission.notification.request();
    if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
      // Handle notification permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification permission is required for updates.')),
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
                'https://lottie.host/bc5d7e4e-4139-400f-9eeb-87ff3a9f5bff/HxSUif2vte.json',
                'Your gateway to hassle-free rentals.',
              ),
              _buildOnboardingPage(
                'Redefining Rental Experience',
                'https://lottie.host/ae885a7f-3902-4275-9f7d-e794f3c89f99/NCje6C18ig.json',
                'Post, Find, Connect, Rent In-Out.',
              ),
              _buildOnboardingPage(
                'Secure and Reliable',
                'https://lottie.host/fb1d757e-bedd-4267-bbf6-9c7183e1fdd8/9NAdBOurJd.json',
                'Rent Smarter, Live Better.',
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
                      await requestPermissions(); // Request permissions
                      widget.onDone();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
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
              count: 3,
              effect: const JumpingDotEffect(
                activeDotColor: AppColors.primaryColor,
              ), // Customize the dot effect
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(String title, String imagePath, String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(imagePath, height: 400, width: 800, fit: BoxFit.contain),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
