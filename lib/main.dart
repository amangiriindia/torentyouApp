import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:try_app/pages/splashScreen.dart';
import 'constant/user_constant.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'service/database_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await UserConstant.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800), // Reference design size (width, height)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final title = message.notification?.title ?? "No Title";
  final text = message.notification?.body ?? "No Text";
  final image = message.notification?.android?.imageUrl ?? null;
  final Map<String, dynamic> data = message.data;
  final name = data.containsKey('name') ? data['name'] : null;

  print("Background Message: $title, $text");

  final DatabaseHelper _dbHelper = DatabaseHelper();
  await _dbHelper.addNotification(
    title: title,
    text: text,
    image: image,
    name: name,
  );
}