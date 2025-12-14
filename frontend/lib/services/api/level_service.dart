import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class LevelService {
  // Backend URL - Platform'a göre otomatik
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://localhost:8000/api/v1';
  }

  /// Tüm aktif levelleri backend'den çeker
  static Future<List<Map<String, dynamic>>> getLevels() async {
    final Uri url = Uri.parse('$baseUrl/levels');
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data =
          json.decode(response.body) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> item) => item)
          .toList();
    }

    throw HttpException(
      'Failed to fetch levels (${response.statusCode})',
      uri: url,
    );
  }

  /// Belirli level bilgisini backend'den çeker
  static Future<Map<String, dynamic>?> getLevel(int levelNumber) async {
    try {
      final Uri url = Uri.parse('$baseUrl/levels/$levelNumber');
      final http.Response response = await http.get(
        url,
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
