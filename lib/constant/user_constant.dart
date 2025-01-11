import 'package:shared_preferences/shared_preferences.dart';

class UserConstant {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user data
  static Future<void> saveUserData(Map<String, dynamic> data) async {
    await _prefs.setInt('USER_ID', data['id']);
    await _prefs.setString('NAME', data['name'] ?? '');
    await _prefs.setString('EMAIL', data['email'] ?? '');
    await _prefs.setString('CONTACT', data['contact'] ?? '');
    await _prefs.setString('ABOUT', data['about'] ?? '');
    await _prefs.setString('PROFILE', data['profile'] ?? '');
  }

  // Retrieve user data
  static int get USER_ID => _prefs.getInt('USER_ID') ?? 0;
  static String get NAME => _prefs.getString('NAME') ?? '';
  static String get EMAIL => _prefs.getString('EMAIL') ?? '';
  static String get CONTACT => _prefs.getString('CONTACT') ?? '';
  static String get ABOUT => _prefs.getString('ABOUT') ?? '';
  static String get PROFILE => _prefs.getString('PROFILE') ?? '';

  // Clear user data
  static Future<void> clearUserData() async {
    await _prefs.clear();
  }
}
