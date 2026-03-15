import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart';

import 'app_language.dart';

class TranslationService {
  TranslationService._();

  static final TranslationService instance = TranslationService._();
  static const Map<String, Map<AppLanguage, String>> _manualTranslations = {
    'Foundations of Jainism': {
      AppLanguage.hindi: 'जैन धर्म की नींव',
      AppLanguage.gujarati: 'જૈન ધર્મના આધાર',
    },
    'The Tirthankaras': {
      AppLanguage.hindi: 'तीर्थंकर',
      AppLanguage.gujarati: 'તીર્થંકરો',
    },
  };

  final GoogleTranslator _translator = GoogleTranslator();
  final Map<String, String> _cache = <String, String>{};
  final Map<String, Future<String>> _inFlight = <String, Future<String>>{};

  /// Returns the cached translation synchronously, or null if not yet cached.
  String? getCached(String text, AppLanguage language) {
    if (language == AppLanguage.english) return text;
    final manual = _manualTranslation(text, language);
    if (manual != null) {
      return manual;
    }
    return _cache['${language.code}::$text'];
  }

  Future<String> translate(String text, AppLanguage language) {
    final trimmed = text.trim();
    if (trimmed.isEmpty || language == AppLanguage.english) {
      return SynchronousFuture<String>(text);
    }

    final cacheKey = '${language.code}::$text';
    final manual = _manualTranslation(text, language);
    if (manual != null) {
      _cache[cacheKey] = manual;
      return SynchronousFuture<String>(manual);
    }

    final cached = _cache[cacheKey];
    if (cached != null) {
      return SynchronousFuture<String>(cached);
    }

    final pending = _inFlight[cacheKey];
    if (pending != null) {
      return pending;
    }

    final request = _translateAndCache(
      cacheKey: cacheKey,
      text: text,
      language: language,
    );
    _inFlight[cacheKey] = request;
    return request;
  }

  Future<String> _translateAndCache({
    required String cacheKey,
    required String text,
    required AppLanguage language,
  }) async {
    try {
      final translated = await _translator.translate(text, to: language.code);
      final output = translated.text.trim().isEmpty ? text : translated.text;
      _cache[cacheKey] = output;
      return output;
    } catch (_) {
      _cache[cacheKey] = text;
      return text;
    } finally {
      _inFlight.remove(cacheKey);
    }
  }

  String? _manualTranslation(String text, AppLanguage language) {
    return _manualTranslations[text]?[language];
  }
}
