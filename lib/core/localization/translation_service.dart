import 'package:translator/translator.dart';

import 'app_language.dart';

class TranslationService {
  TranslationService._();

  static final TranslationService instance = TranslationService._();

  final GoogleTranslator _translator = GoogleTranslator();
  final Map<String, String> _cache = <String, String>{};

  Future<String> translate(String text, AppLanguage language) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || language == AppLanguage.english) {
      return text;
    }

    final cacheKey = '${language.code}::$text';
    final cached = _cache[cacheKey];
    if (cached != null) {
      return cached;
    }

    try {
      final translated = await _translator.translate(text, to: language.code);
      final output = translated.text.trim().isEmpty ? text : translated.text;
      _cache[cacheKey] = output;
      return output;
    } catch (_) {
      _cache[cacheKey] = text;
      return text;
    }
  }
}
