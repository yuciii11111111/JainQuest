import 'package:flutter/material.dart';

enum AppLanguage {
  english(code: 'en', name: 'English', nativeName: 'English'),
  hindi(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
  gujarati(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી');

  final String code;
  final String name;
  final String nativeName;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
