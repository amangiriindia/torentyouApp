import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_test/consts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<Notification>> _notifications;
  late int userId=0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _notifications = fetchNotifications();
  }
  // Fetch user data from SharedPreferences
  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      userId = prefs.getInt('userId') ?? 0;
    });
  }
  Future<List<Notification>> fetchNotifications() async {
    final response = await http.get(Uri.parse('${AppConstant.API_URL}/api/v1/notification/user-all-notification/1'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Notification.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Notification>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications available.'));
          } else {
            final notifications = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(
                  context,
                  color: _getColorForType(notification.type),
                  icon: _getIconForType(notification.type),
                  heading: notification.type,
                  text: notification.text,
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, {
    required Color color,
    required IconData icon,
    required String heading,
    required String text,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          heading,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(text),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'New Rent':
        return Colors.blueAccent;
    // Add other cases for different notification types
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'New Rent':
        return Icons.car_rental; // Replace with appropriate icon
    // Add other cases for different notification types
      default:
        return Icons.notifications;
    }
  }
}

class Notification {
  final int id;
  final String type;
  final String text;
  final int value;
  final int userId;
  final int view;
  final String dateTime;

  Notification({
    required this.id,
    required this.type,
    required this.text,
    required this.value,
    required this.userId,
    required this.view,
    required this.dateTime,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      type: json['type'],
      text: json['text'],
      value: json['value'],
      userId: json['user_id'],
      view: json['view'],
      dateTime: json['date_time'],
    );
  }
}
