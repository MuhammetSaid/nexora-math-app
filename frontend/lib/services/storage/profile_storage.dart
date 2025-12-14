import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_profile.dart';

class ProfileStorage {
  static const String _userIdKey = 'profile_user_id';
  static const String _nameKey = 'profile_name';
  static const String _emailKey = 'profile_email';
  static const String _localeKey = 'profile_locale';
  static const String _countryKey = 'profile_country';

  static Future<void> save(UserProfile profile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, profile.userId);
    await prefs.setString(_nameKey, profile.name);
    await prefs.setString(_emailKey, profile.email);
    if (profile.locale != null) {
      await prefs.setString(_localeKey, profile.locale!);
    }
    if (profile.country != null) {
      await prefs.setString(_countryKey, profile.country!);
    }
  }

  static Future<UserProfile?> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, Object?> data = <String, Object?>{
      'user_id': prefs.getString(_userIdKey),
      'name': prefs.getString(_nameKey),
      'email': prefs.getString(_emailKey),
      'locale': prefs.getString(_localeKey),
      'country': prefs.getString(_countryKey),
    };
    return UserProfile.fromStorage(data);
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_localeKey);
    await prefs.remove(_countryKey);
  }
}
