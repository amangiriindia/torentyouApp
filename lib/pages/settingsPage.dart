import 'package:flutter/material.dart';
import '../constant/user_constant.dart';
import '../consts.dart';
import 'splashScreen.dart';

class SettingsPage extends StatefulWidget {
  final String heading;

  const SettingsPage({Key? key, required this.heading}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22.49,
            fontWeight: FontWeight.w500,
            height: 18.74 / 12.49, // Line height based on font size
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryTextColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0, // Removes shadow for a cleaner look
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        children: [
          Text(
            widget.heading,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          _buildSettingOption(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            switchWidget: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ),
          const Divider(),
          _buildSettingOption(
            icon: Icons.notifications,
            title: "Notifications",
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Notification Settings (Future implementation)
            },
          ),
          const Divider(),
          _buildSettingOption(
            icon: Icons.lock,
            title: "Privacy Policy",
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Privacy Policy (Future implementation)
            },
          ),
          const Divider(),
          _buildSettingOption(
            icon: Icons.info,
            title: "About Us",
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to About Us (Future implementation)
            },
          ),
          const Divider(),
          _buildSettingOption(
            icon: Icons.logout,
            title: "Logout",
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Logout Functionality
               UserConstant.clearUserData();
                 Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SplashScreen(),
                              ),
                            );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    Widget? switchWidget,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: AppColors.primaryTextColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            if (switchWidget != null) ...[
              switchWidget,
            ] else if (trailing != null) ...[
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}
