import 'dart:convert'; // For encoding data
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_test/constant/user_constant.dart';
import '../components/Button.dart';
import '../consts.dart';
import 'package:http/http.dart' as http; // For making HTTP requests

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  bool _isEditing = false;
  bool _showChangePassword = false;
  bool _isLoading = false; // For showing loading state
  late int userId=0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch user data from SharedPreferences
  Future<void> _loadUserData() async {
    
    setState(() {
      _nameController.text = UserConstant.NAME ?? 'Enter your name';
      _contactController.text = UserConstant.CONTACT ?? 'Enter your Phone Number';
      _aboutController.text = UserConstant.ABOUT ?? 'About text here';
      _emailController.text = UserConstant.NAME ?? 'Enter your email';
      userId = UserConstant.USER_ID ?? 0;
    });
  }


  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _toggleChangePassword() {
    setState(() {
      _showChangePassword = !_showChangePassword;
    });
  }




  // Function to handle profile update
  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

   // Retrieve user ID from SharedPreferences

    // API request to update profile
    try {
      var url = Uri.parse('${AppConstant.API_URL}api/v1/seller/user-update-profile');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": userId,
          "name": _nameController.text,
          "email": _emailController.text,
          "contact": _contactController.text,
          "about": _aboutController.text,
        }),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // Update SharedPreferences
        prefs.setString('userName', _nameController.text);
        prefs.setString('userPhone', _contactController.text);
        prefs.setString('userAbout', _aboutController.text);
        prefs.setString('userEmail', _emailController.text);

        _toggleEditing(); // Exit editing mode after a successful update
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message'] ?? 'Failed to update profile'),
        ));
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }




  // Function to handle password change
  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
      ));
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Replace with your API URL for changing the password
      var url = Uri.parse('${AppConstant.API_URL}api/v1/seller/user-change-password');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": userId,
          "password": _newPasswordController.text,
        }),
      );

      var responseData = jsonDecode(response.body);
      print(response.body);
      print(response.statusCode);
      print(userId);
      if (response.statusCode == 200 && responseData['success']) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
        _toggleChangePassword(); // Exit change password mode after a successful update
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message'] ?? 'Failed to change password'),
        ));
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.primaryTextColor],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Image Section
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: Center(
                  child: Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text[0].toUpperCase()
                        : '',
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Profile Info
            _buildProfileField('Name', _nameController, _isEditing),
            _buildProfileField('Contact', _contactController, _isEditing),
            _buildProfileField('Email', _emailController, _isEditing),
            _buildProfileField('About', _aboutController, _isEditing, maxLines: 3),
            const SizedBox(height: 20),
            // Update Profile Button
            Visibility(
              visible: _isEditing,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryTextColor, AppColors.primaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onPressed: _updateProfile, // Call the API function here
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Transparent to show gradient
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0, // Remove shadow
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator() // Show loading indicator while updating
                      : const Text(
                    'Update Profile',
                    style: TextStyle(
                      color: Colors.white, // White text color
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Change Password Section
            TextButton(
              onPressed: _toggleChangePassword,
              child: Text(
                _showChangePassword ? 'Cancel' : 'Change Password',
                style: const TextStyle(color: AppColors.primaryTextColor),
              ),
            ),
            Visibility(
              visible: _showChangePassword,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('New Password', _newPasswordController, obscureText: true),
                  _buildTextField('Confirm Password', _confirmPasswordController, obscureText: true),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryColor, AppColors.primaryTextColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _changePassword();
                        // Add functionality to change password
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Transparent to show gradient
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0, // Remove shadow
                      ),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.white, // White text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GradientFloatingActionButton(
        onPressed: _toggleEditing,
        icon: _isEditing ? Icons.cancel : Icons.edit,
        startColor: AppColors.primaryTextColor,
        endColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, bool isEditing, {int? maxLines}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: !isEditing,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
