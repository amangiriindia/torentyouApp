import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      if (_controller.page == 3.0) {
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
        SnackBar(
          content: Text(
            'Location permission is required for better functionality.',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );
    }

    PermissionStatus notificationStatus = await Permission.notification.request();
    if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notification permission is required for updates.',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                'assets/images/onboarding1.jpg',
                'Your gateway to hassle-free rentals.',
                isLocal: true,
                isImage: true,
              ),
              _buildOnboardingPage(
                'Connect with a Vast Network',
                'assets/anim/anim_7.json',
                'Discover endless rental opportunities around you.',
                isLocal: true,
                isImage: false,
              ),
              _buildOnboardingPage(
                'Explore Everywhere',
                'assets/anim/anim_8.json',
                'Find rentals in every corner, anytime, anywhere.',
                isLocal: true,
                isImage: false,
              ),
              _buildOnboardingPage(
                'Secure and Reliable Rentals',
                'assets/anim/anim_9.json',
                'Experience trusted and secure rental transactions.',
                isLocal: true,
                isImage: false,
              ),
            ],
          ),
          if (showGetStartedButton)
            Align(
              alignment: const Alignment(0, 0.75),
              child: Padding(
                padding: EdgeInsets.all(20.w),
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
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    title: "Get Started",
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryTextColor,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Container(
            alignment: const Alignment(0, 0.9),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: JumpingDotEffect(
                activeDotColor: AppColors.primaryColor,
                dotHeight: 12.h,
                dotWidth: 12.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
      String title,
      String? imagePath,
      String description, {
        bool isLocal = false,
        bool isImage = false,
      }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isImage
                ? Container(
              height: 400.h,
              width: 1.sw, // Use screen width for better responsiveness
              constraints: BoxConstraints(maxWidth: 600.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  imagePath!,
                  height: 400.h,
                  width: 1.sw,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 50),
                ),
              ),
            )
                : isLocal
                ? Lottie.asset(
              imagePath!,
              height: 400.h,
              width: 1.sw,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, size: 50),
            )
                : Lottie.network(
              imagePath!,
              height: 400.h,
              width: 1.sw,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, size: 50),
            ),
            SizedBox(height: 30.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}