import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qanon/services/secrets.dart';


class AIService {
  static const String _apiKey = geminiApiKey;
  static const String _model = 'gemini-2.5-flash'; // بديل حديث
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/';

  Future<String> getAdvice(String question) async {
    try {
      final url = Uri.parse('$_baseUrl$_model:generateContent?key=$_apiKey');

      const systemPrompt = '''أنت مستشار قانوني متخصص في القانون الأردني...
(نفس النص الذي عندك)
''';

      final body = jsonEncode({
        // حط التوجيه كنص نظامي منفصل
        'systemInstruction': {
          'role': 'user', // حسب المواصفات، محتوى نصي فقط مع role
          'parts': [{'text': systemPrompt}]
        },
        // محادثة المستخدم
        'contents': [
          {'role': 'user', 'parts': [{'text': question}]},
        ]
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return (text is String && text.isNotEmpty)
            ? text
            : 'عذراً، لم أتمكن من معالجة استفسارك. يرجى المحاولة مرة أخرى.';
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return '❌ **خطأ في إعدادات الخدمة**\n\nيرجى التأكد من صحة الـ API Key وصلاحياته.';
      } else if (response.statusCode == 429) {
        return '⏰ **تم تجاوز الحد المسموح**\n\nحاول لاحقاً أو استخدم خطة أعلى.';
      } else {
        return '❌ **خطأ في الخدمة**\n\n${response.body}';
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('SocketException') || msg.contains('network') || msg.contains('connection')) {
        return '🌐 **مشكلة اتصال**\nتحقق من الإنترنت وحاول مجدداً.';
      } else if (msg.contains('timeout')) {
        return '⏱️ **انتهاء مهلة الاتصال**\nحاول مجدداً.';
      } else {
        return '❓ **خطأ غير متوقع**\nأعد المحاولة أو أعد تشغيل التطبيق.';
      }
    }
  }

  Future<String> getCategoryAdvice(String category, String question) async {
    final contextual = 'في إطار $category في القانون الأردني:\n$question';
    return getAdvice(contextual);
  }
}
