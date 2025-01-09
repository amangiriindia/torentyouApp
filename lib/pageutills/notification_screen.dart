import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
          backgroundColor: Colors.white, // Set a background color for the dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners for the dialog
          ),
          title: Text(
            notification['title'] ?? 'No Title',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(  // Wrap the content in a scrollable widget
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
                borderRadius: BorderRadius.circular(10), // Rounded image corners
                child: Image.network(
                    notification['image'],
                    width: 400, // Make image take the full width of the dialog
                    height: 200, // Set a fixed height for the image
                    fit: BoxFit.contain, // Ensure the image covers the area properly
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return const Center(
                      child: Text('Image not available'),
                    );
                  },
          ),
        )
            : const SizedBox.shrink(), // If no image, don't display anything
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
          content: const Text("Are you sure you want to delete all notifications?"),
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
        backgroundColor: AppColors.primaryTextColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _showClearAllDialog,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryTextColor,
              AppColors.primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: notifications.isEmpty
            ? const Center(
          child: Text(
            'No notifications yet!',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        )
            : ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // More rounded corners
                ),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16), // More padding for spacious design
                  leading: ClipOval(
                    child: notification['image'] != 'NA'
                        ? Image.network(
                      notification['image'],
                      width: 50, // Custom width for the image
                      height: 50, // Custom height for the image
                      fit: BoxFit.cover, // Ensure the image is well-proportioned
                    )
                        : const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    notification['title'],
                    maxLines: 2, // Limit to 1 line
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Slightly larger font size for modern feel
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    notification['text'] ?? "No Text",
                    maxLines: 1, // Limit to 1 line
                    overflow: TextOverflow.ellipsis, // Show ellipsis when overflow occurs
                    style: TextStyle(color: Colors.black54),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios, // Modern arrow icon to indicate navigation
                    size: 18,
                    color: Colors.grey,
                  ),
                  onTap: () => _showNotificationDetails(notification),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}