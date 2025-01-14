import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lottie/lottie.dart';

import '../consts.dart';
import '../service/database_helper.dart';
import '../service/firebase_notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadNotifications();

    // Initialize Firebase Notification Service
    NotificationService().init();

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Full message: ${message.toMap()}');

      final title = message.notification?.title ?? "No Title";
      final text = message.notification?.body ?? "No Text";
      final image = message.notification?.android?.imageUrl ?? null;
      final Map<String, dynamic> data = message.data;
      final name = data.containsKey('name') ? data['name'] : null;

      print('Title: $title');
      print('Text: $text');
      print('Image: $image');
      print('Name: $name');

      await _dbHelper.addNotification(
        title: title,
        text: text,
        image: image,
        name: name,
      );
    });

    // Listen for when the app is opened via a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked! ${message.toMap()}');
      // You can handle navigation or other actions here
    });
  }

  Future<void> _loadNotifications() async {
    final data = await _dbHelper.getNotifications();
    setState(() {
      notifications = data;
    });
  }

  Future<void> _clearNotifications() async {
    await _dbHelper.deleteAllNotifications();
    _loadNotifications();
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              Colors.white, // Set a background color for the dialog
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Rounded corners for the dialog
          ),
          title: Text(
            notification['title'] ?? 'No Title',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            // Wrap the content in a scrollable widget
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' ${notification['text'] ?? "No Text"}',
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 15),
                // Show the image if available, otherwise show a placeholder message
                notification['image'] != null && notification['image'] != 'NA'
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded image corners
                        child: Image.network(
                          notification['image'],
                          width:
                              400, // Make image take the full width of the dialog
                          height: 200, // Set a fixed height for the image
                          fit: BoxFit
                              .contain, // Ensure the image covers the area properly
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return const Center(
                              child: Text('Image not available'),
                            );
                          },
                        ),
                      )
                    : const SizedBox
                        .shrink(), // If no image, don't display anything
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete All Notifications"),
          content:
              const Text("Are you sure you want to delete all notifications?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _clearNotifications();
                Navigator.pop(context);
              },
              child: const Text(
                "Delete All",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.primaryColor),
            onPressed: _showClearAllDialog,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: notifications.isEmpty
            ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/anim/anim_4.json',
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No notifications yet!',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
            )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Card(
                      elevation: 3, // Subtle shadow for a modern look
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15), // Rounded corners for modern aesthetics
                      ),
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              15), // Rounded corners for the gradient background
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor, // Start color of the gradient
                              AppColors.primaryTextColor, // End color of the gradient
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8), // Reduce padding
                          leading: ClipOval(
                            child: notification['image'] != 'NA'
                                ? Image.network(
                                    notification['image'],
                                    width:
                                        40, // Reduced width for compact design
                                    height:
                                        40, // Reduced height for compact design
                                    fit: BoxFit.cover,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.blue
                                        .shade100, // Softer color for modern design
                                    child: Icon(
                                      Icons.notifications,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                          ),
                          title: Text(
                            notification['title'],
                            maxLines: 1, // Limit to 1 line
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16, // Modern and compact font size
                              color: AppColors.backgroundColor,
                            ),
                          ),
                          subtitle: Text(
                            notification['text'] ?? "No Text",
                            maxLines: 1, // Limit to 1 line
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14, // Slightly smaller for compactness
                              color: Colors.white70,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors
                                  .grey.shade200, // Light background for icon
                              shape:
                                  BoxShape.circle, // Circular icon background
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors
                                  .grey.shade700, // Softer tone for the arrow
                            ),
                          ),
                          onTap: () => _showNotificationDetails(notification),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
