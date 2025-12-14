import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/user_profile.dart';

class UserService {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://localhost:8000/api/v1';
  }

  static Future<UserProfile?> fetchProfile(String userId) async {
    final Uri url = Uri.parse('$baseUrl/users/$userId');
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    }
    return null;
  }

  static Future<UserProfile> createProfile({
    required String name,
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users');
    final Map<String, dynamic> body = <String, dynamic>{
      'username': name,
      'email': email,
      'password': password,
      'locale': 'tr',
    };

    final http.Response response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    }

    throw HttpException(
      'Failed to create profile (${response.statusCode})',
      uri: url,
    );
  }

  static Future<UserProfile> updateProfile({
    required String userId,
    String? name,
    String? email,
    String? password,
    int? level,
  }) async {
    final Uri url = Uri.parse('$baseUrl/users/$userId');
    final Map<String, dynamic> body = <String, dynamic>{};
    if (name != null && name.isNotEmpty) body['username'] = name;
    if (email != null && email.isNotEmpty) body['email'] = email;
    if (password != null && password.isNotEmpty) body['password'] = password;
    if (level != null) body['level'] = level;

    final http.Response response = await http.put(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    }

    throw HttpException(
      'Failed to update profile (${response.statusCode})',
      uri: url,
    );
  }
}
