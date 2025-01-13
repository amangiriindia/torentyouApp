import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:try_test/constant/user_constant.dart';
import 'package:try_test/consts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<Notification>> _notifications;
  late int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _notifications = fetchNotifications();
  }

  Future<void> _loadUserData() async {
    print(UserConstant.USER_ID);
    setState(() {
      userId = UserConstant.USER_ID ?? 0;
    });
  }

  Future<List<Notification>> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppConstant.API_URL}api/v1/notification/user-all-notification/$userId'),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Notification.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print(response.statusCode);
        throw Exception('No notification found');
      } else {
        print('Error Response Body: ${response.body}');
        throw Exception(
            'Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception(
          'An unexpected error occurred while fetching notifications.');
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
            return _buildNoNotificationsView(context);
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

  Widget _buildNoNotificationsView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 100, color: Colors.white),
          const SizedBox(height: 20),
          const Text(
            "No Notifications Yet!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "You're all caught up. Check back later for updates.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
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
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'New Rent':
        return Icons.car_rental;
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
