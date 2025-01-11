import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:try_test/pages/payment_test.dart';
import 'package:try_test/service/database_helper.dart';
import 'components/test_google_map.dart';
import 'constant/user_constant.dart';
import 'firebase_options.dart';
import 'pages/PostAdsPage.dart';
import 'pages/auth/loginPage.dart';
import 'pages/splashScreen.dart';
import 'pageutills/notification_screen.dart'; // Make sure this file exists
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
await UserConstant.init();
  // Register the background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Extract notification details
  final title = message.notification?.title ?? "No Title";
  final text = message.notification?.body ?? "No Text";
  final image = message.notification?.android?.imageUrl ?? null;
  final Map<String, dynamic> data = message.data;
  final name = data.containsKey('name') ? data['name'] : null;

  // Log for debugging
  print("Background Message: $title, $text");

  // Store notification in the database
  final DatabaseHelper _dbHelper = DatabaseHelper();
  await _dbHelper.addNotification(
    title: title,
    text: text,
    image: image,
    name: name,
  );
}
