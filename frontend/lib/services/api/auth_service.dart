import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/user_profile.dart';
import 'user_service.dart';

class AuthService {
  static String get baseUrl => UserService.baseUrl;

  static Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse('$baseUrl/auth/login');
    final Map<String, dynamic> body = <String, dynamic>{
      'email': email,
      'password': password,
    };

    final http.Response response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    }

    if (response.statusCode == 401) {
      throw HttpException('Invalid credentials', uri: url);
    }

    throw HttpException(
      'Login failed (${response.statusCode})',
      uri: url,
    );
  }
}
