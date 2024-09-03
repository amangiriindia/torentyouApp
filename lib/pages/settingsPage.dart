import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final String heading;

  const SettingsPage({Key? key, required this.heading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(heading), // Display the heading in the AppBar
      ),
      body: Center(
        child: Text('Content for $heading'), // Display the heading in the body
      ),
    );
  }
}
