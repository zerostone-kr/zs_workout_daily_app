import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import 'dart:convert';

class LocalStorageService {
  static const String userProfileKey = 'userProfile';

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userProfileKey, jsonEncode(profile.toJson()));
  }

  static Future<UserProfile?> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString(userProfileKey);
    if (profileString == null) return null;
    return UserProfile.fromJson(jsonDecode(profileString));
  }
}
