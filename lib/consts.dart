import 'package:flutter/material.dart';

class AppColors {
  // Primary Color: The main color used for branding and interactive elements.
  static const Color primaryColor = Color(0xffa9468b);

  // Secondary Color: Used for accents, highlights, or less prominent elements.
  static const Color secondaryColor = Color(0xffebd9dc);

  // Background Color: Used for the main background of the app.
  static const Color backgroundColor = Colors.white;

  // Text Colors
  static const Color primaryTextColor = Color(0xff09285a); // Dark blue
  static const Color secondaryTextColor = Colors.grey; // For less important text

  // Additional Colors
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;

  //card outline color

  static const Color cardOutlineColor = Color(0xffa9468b);

  // navbar tint color
  static Color navbarPillColor = const Color(0xffa9468b).withOpacity(0.35);

  // Divider Color
  static Color dividerColor = Colors.grey.shade900;
}

class AppConstant {
  static const String API_URL = 'http://192.168.231.249:8080/';
  static const String MAP_KEY = 'AIzaSyBd98NLneHO0QtwIvzfaLrkG4HMU1MdD_E';
}

