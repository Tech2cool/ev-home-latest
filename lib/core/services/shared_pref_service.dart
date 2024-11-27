import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String key = 'user';

  // Store user
  static Future<void> storeUser(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  // Retrieve user
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(key);
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  // Update user
  static Future<void> updateUser(String key, Map<String, dynamic> data) async {
    await storeUser(key, data);
  }

  // Delete user
  static Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
