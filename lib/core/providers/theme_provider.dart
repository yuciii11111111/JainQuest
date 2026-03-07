import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

// ============================================================================
// Theme Mode Provider
// ============================================================================

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  Future<void> toggleTheme() async {
    state = ThemeMode.light;
    await StorageService.saveThemeMode(ThemeMode.light);
  }

  Future<void> setThemeMode(ThemeMode _) async {
    state = ThemeMode.light;
    await StorageService.saveThemeMode(ThemeMode.light);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
