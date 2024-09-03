import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        color: Colors.white, // Set the background color of the page to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildNotificationCard(
                context,
                color: Colors.blueAccent,
                icon: Icons.chat,
                heading: 'New Message',
                text: 'You have received a new message from John Doe.',
              ),
              _buildNotificationCard(
                context,
                color: Colors.greenAccent,
                icon: Icons.check_circle,
                heading: 'Post Successful',
                text: 'Your post has been successfully published.',
              ),
              _buildNotificationCard(
                context,
                color: Colors.redAccent,
                icon: Icons.error,
                heading: 'Subscription Expired',
                text: 'Your subscription has expired. Please renew it.',
              ),
              _buildNotificationCard(
                context,
                color: Colors.orangeAccent,
                icon: Icons.info,
                heading: 'System Update',
                text: 'A new update is available for the app.',
              ),
              _buildNotificationCard(
                context,
                color: Colors.purpleAccent,
                icon: Icons.star,
                heading: 'Special Offer',
                text: 'You have a special offer waiting for you!',
              ),
              _buildNotificationCard(
                context,
                color: Colors.cyanAccent,
                icon: Icons.local_offer,
                heading: 'Limited Time Deal',
                text: 'Check out our limited-time deals available now.',
              ),
            ],
          ),
        ),
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
}
