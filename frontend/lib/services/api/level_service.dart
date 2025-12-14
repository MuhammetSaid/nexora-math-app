import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class LevelService {
  // Backend URL - Platform'a göre otomatik
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android emulator için özel IP
      return 'http://10.0.2.2:8000/api/v1';
    } else {
      // iOS simulator, web, desktop için localhost
      return 'http://localhost:8000/api/v1';
    }
  }

  /// Level bilgisini backend'den çeker
  static Future<Map<String, dynamic>?> getLevel(int levelNumber) async {
    try {
      final url = Uri.parse('$baseUrl/levels/$levelNumber');

      print(' API İsteği: $url');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print(' Response Status: ${response.statusCode}');
      print(' Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print(' Level verisi başarıyla alındı!');
        return data;
      } else {
        print(' Hata: ${response.statusCode}');
        print(' Mesaj: ${response.body}');
        return null;
      }
    } catch (e) {
      print(' API Hatası: $e');
      return null;
    }
  }
}
