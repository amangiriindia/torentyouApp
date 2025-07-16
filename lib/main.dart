import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:try_app/pages/splashScreen.dart';
import 'package:try_app/payment/payment_gayways.dart';
import 'constant/user_constant.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'service/database_helper.dart';

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

