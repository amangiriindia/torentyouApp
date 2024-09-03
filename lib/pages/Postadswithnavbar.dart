import 'package:flutter/material.dart';
import '../consts.dart';
import 'PostAdsPage.dart'; // Import the content widget

class PostAdsWithNavPage extends StatelessWidget {
  const PostAdsWithNavPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post Your Requirement', // Updated title text
          style: TextStyle(color: Colors.black), // Change text color to white
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryTextColor,
              ],
            ),
          ),
        ),
      ),

      body: const PostAdsContent(), // Use the extracted content widget
    );
  }
}
