import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BotService {
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

  /// Bot'un soruyu çözmesini ister
  ///
  /// Returns: {
  ///   "answer": str,        // Bot'un cevabı
  ///   "solve_time": float,  // Çözüm süresi (saniye)
  ///   "success": bool,      // Başarılı mı?
  ///   "method": str,        // "llm" veya "simulation"
  ///   "difficulty": int     // Zorluk seviyesi
  /// }
  static Future<Map<String, dynamic>?> solveQuestion({
    required String levelId,
    required int difficulty,
    required String hint1,
    required String hint2,
    required String solutionExplanation,
    required String answerValue,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/bot/solve');

      print('🤖 Bot API İsteği: $url');

      final requestBody = {
        'level_id': levelId,
        'difficulty': difficulty,
        'hint1': hint1,
        'hint2': hint2,
        'solution_explanation': solutionExplanation,
        'answer_value': answerValue,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      print('🤖 Bot Response Status: ${response.statusCode}');
      print('🤖 Bot Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print('✅ Bot çözüm verisi başarıyla alındı!');
        return data;
      } else {
        print('❌ Bot API Hatası: ${response.statusCode}');
        print('❌ Mesaj: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Bot API Exception: $e');
      return null;
    }
  }
}
