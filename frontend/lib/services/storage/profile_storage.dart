import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_profile.dart';

class ProfileStorage {
  static const String _userIdKey = 'profile_user_id';
  static const String _nameKey = 'profile_name';
  static const String _emailKey = 'profile_email';
  static const String _localeKey = 'profile_locale';
  static const String _countryKey = 'profile_country';
  static const String _levelKey = 'profile_level';
  static const String _xpKey = 'profile_xp';
  static const String _xpDdKey = 'profile_xp_dd';
  static const String _diamondKey = 'profile_diamond';
  static const String _hintsKey = 'profile_hints';
  static const String _statusKey = 'profile_status';
  static const String _avatarPathKey = 'profile_avatar_path';

  static Future<void> save(UserProfile profile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, profile.userId);
    await prefs.setString(_nameKey, profile.name);
    await prefs.setString(_emailKey, profile.email);
    await prefs.setInt(_levelKey, profile.level);
    await prefs.setInt(_xpKey, profile.xp);
    await prefs.setInt(_xpDdKey, profile.xpDd);
    await prefs.setInt(_diamondKey, profile.diamond);
    await prefs.setInt(_hintsKey, profile.hints);
    if (profile.status != null) {
      await prefs.setString(_statusKey, profile.status!);
    }
    if (profile.avatarPath != null) {
      await prefs.setString(_avatarPathKey, profile.avatarPath!);
    }
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
      'level': prefs.getInt(_levelKey),
      'xp': prefs.getInt(_xpKey),
      'xp_dd': prefs.getInt(_xpDdKey),
      'diamond': prefs.getInt(_diamondKey),
      'hints': prefs.getInt(_hintsKey),
      'status': prefs.getString(_statusKey),
      'avatar_path': prefs.getString(_avatarPathKey),
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
    await prefs.remove(_levelKey);
    await prefs.remove(_xpKey);
    await prefs.remove(_xpDdKey);
    await prefs.remove(_diamondKey);
    await prefs.remove(_hintsKey);
    await prefs.remove(_statusKey);
    await prefs.remove(_avatarPathKey);
  }
}
