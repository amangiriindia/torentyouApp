// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static void initialize() {
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'), // Ensure you have an appropriate launcher icon
//     );
//
//     _localNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   static Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'main_channel', // ID for the channel
//         'Main Channel', // Name for the channel
//         importance: Importance.high,
//         priority: Priority.high,
//       ),
//     );
//
//     await _localNotificationsPlugin.show(
//       0, // Notification ID
//       title,
//       body,
//       notificationDetails,
//     );
//   }
// }