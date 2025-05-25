import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not granted permission');
    }

    // Retrieve and print the FCM token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print("FCM Token: $token");
    } else {
      print("Failed to retrieve FCM token.");
    }

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Foreground notification received:');
        print('Title: ${message.notification!.title}');
        print('Body: ${message.notification!.body}');
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }
}
