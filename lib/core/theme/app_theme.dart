import 'package:flutter/material.dart';

import '../navigation/app_navigator.dart';

// ============================================================================
// Premium Dark Theme Colors
// ============================================================================

class AppColors {
  AppColors._();

  static const Color inkBlack = Color(0xFF000000);
  static const Color softCream = Color(0xFFFBF0F4);
  static const Color warmOrange = Color(0xFFED8F45);

  // Backgrounds
  // Transparent base to let animated gradient show through
  // Transparent base to let animated gradient show through
  static const Color backgroundBase = Colors.transparent;
  // Semi-transparent warm charcoal for cards
  static const Color backgroundCard = Color(0xD9000000);
  // Slightly lighter warm surface
  static const Color backgroundElevated = Color(0xCC24150A);

  // Text
  static const Color textPrimary = softCream;
  static const Color textSecondary = Color(0xFFFFD9BC);
  static const Color textMuted = Color(0xFFD5B8A2);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFFFFA362),
    warmOrange,
    Color(0xFFD8782D),
  ];

  static const List<Color> accentGradient = [
    softCream,
    Color(0xFFF7D5C0),
    Color(0xFFF3BE95),
  ];

  static const List<Color> successGradient = [
    Color(0xFFF5B07A),
    warmOrange,
    Color(0xFFC06A2E),
  ];

  static const List<Color> warmGradient = [
    softCream,
    Color(0xFFF8DFE8),
    Color(0xFFF1C9A8),
  ];

  // Solid Accents
  static const Color primary = warmOrange;
  static const Color secondary = Color(0xFFFFA362);
  static const Color highlight = softCream;
  static const Color success = Color(0xFFD8782D);
  static const Color warning = Color(0xFFF0A76A);
  static const Color danger = Color(0xFFE06749);
  static const Color achievementGold = Color(0xFFF3AE72);

  // Glassmorphism
  static const Color glassOverlay = Color(0x26FBF0F4);
  static const Color glassBorder = Color(0x66FBF0F4);
  static const double glassBlur = 24.0;

  // Light Mode (Optional)
  static const Color lightBackground = Colors.transparent;
  static const Color lightCard = softCream;
  static const Color lightElevated = Color(0xFFF7E2EA);
  static const Color lightTextPrimary = Color(0xFF1C140F);
  static const Color lightTextSecondary = Color(0xFF312114);
  static const Color lightTextMuted = Color(0xFF5A3F2B);
  static const Color lightBorder = Color(0x99ED8F45);
}

// ============================================================================
// Spacing System
// ============================================================================

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

// ============================================================================
// Border Radius
// ============================================================================

class AppRadius {
  AppRadius._();

  static const double card = 20;
  static const double pill = 999;
  static const double button = 16;
  static const double small = 12;
  static const double large = 28;
}

// ============================================================================
// Shadows & Elevation
// ============================================================================

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get glassCard => const [];
  static List<BoxShadow> get glowing => const [];
  static List<BoxShadow> get floating => const [];
}

// ============================================================================
// Gradients
// ============================================================================

class AppGradients {
  AppGradients._();

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.primaryGradient,
  );

  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.accentGradient,
  );

  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.successGradient,
  );

  static const LinearGradient warm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.warmGradient,
  );

  static RadialGradient radial(Alignment center, double radius) {
    return RadialGradient(
      center: center,
      radius: radius,
      colors: AppColors.primaryGradient,
    );
  }
}

// ============================================================================
// Typography
// ============================================================================

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'SF Pro';
  static const List<String> fontFamilyFallback = [
    'SF Pro Display',
    'SF Pro Text',
    'San Francisco',
    '.SF Pro Text',
    '.SF Pro Display',
    'Helvetica Neue',
    'Arial',
  ];
}

extension ColorOpacityX on Color {
  /// Opacity helper that uses [withValues] to avoid precision loss.
  Color withOpacityValue(double opacity) {
    final safeOpacity = opacity.clamp(0.0, 1.0).toDouble();
    return withValues(alpha: safeOpacity);
  }
}

// ============================================================================
// Theme Data
// ============================================================================

class AppTheme {
  AppTheme._();

  static const PageTransitionsTheme _smoothPageTransitions =
      PageTransitionsTheme(
    builders: {
      TargetPlatform.android: AppSmoothTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: AppSmoothTransitionsBuilder(),
      TargetPlatform.windows: AppSmoothTransitionsBuilder(),
    },
  );

  static TextTheme _buildTextTheme({
    required Color primary,
    required Color secondary,
    required Color muted,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: primary,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: primary,
        height: 1.25,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: primary,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primary,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
        height: 1.35,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primary,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: primary,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
        height: 1.45,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: secondary,
        height: 1.45,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primary,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: muted,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: 0.5,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondary,
        letterSpacing: 0.4,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: muted,
        letterSpacing: 0.3,
      ),
    ).apply(
      fontFamily: AppTypography.fontFamily,
      fontFamilyFallback: AppTypography.fontFamilyFallback,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTypography.fontFamily,
      fontFamilyFallback: AppTypography.fontFamilyFallback,
      scaffoldBackgroundColor: AppColors.backgroundBase,
      pageTransitionsTheme: _smoothPageTransitions,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.backgroundCard,
        surfaceContainerHighest: AppColors.backgroundElevated,
        outline: AppColors.glassBorder,
        onSurfaceVariant: AppColors.textSecondary,
        error: AppColors.danger,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),

      // Typography
      textTheme: _buildTextTheme(
        primary: AppColors.textPrimary,
        secondary: AppColors.textSecondary,
        muted: AppColors.textMuted,
      ),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.glassBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.backgroundElevated,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary.withOpacityValue(0.35)
              : AppColors.backgroundElevated,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.backgroundElevated,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.backgroundElevated,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.backgroundElevated,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // Input Decoration
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.danger),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: AppSpacing.md,
        ),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        hintStyle: TextStyle(color: AppColors.textMuted),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.fontFamily,
      fontFamilyFallback: AppTypography.fontFamilyFallback,
      scaffoldBackgroundColor: AppColors.lightBackground,
      pageTransitionsTheme: _smoothPageTransitions,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightCard,
        surfaceContainerHighest: AppColors.lightElevated,
        outline: AppColors.lightBorder,
        error: AppColors.danger,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.lightTextPrimary,
        onSurfaceVariant: AppColors.lightTextSecondary,
        onError: AppColors.textPrimary,
      ),

      // Typography
      textTheme: _buildTextTheme(
        primary: AppColors.lightTextPrimary,
        secondary: AppColors.lightTextSecondary,
        muted: AppColors.lightTextMuted,
      ),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
        opacity: 0.98,
      ),
      primaryIconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
        opacity: 0.98,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextPrimary,
          side: const BorderSide(color: AppColors.lightBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightTextMuted,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.lightElevated,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary.withOpacityValue(0.35)
              : AppColors.lightElevated,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.lightElevated,
        contentTextStyle: TextStyle(color: AppColors.lightTextPrimary),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.lightBorder,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: AppSpacing.md,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.danger),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: AppSpacing.md,
        ),
        labelStyle: TextStyle(color: AppColors.lightTextSecondary),
        hintStyle: TextStyle(color: AppColors.lightTextMuted),
        prefixIconColor: AppColors.lightTextSecondary,
        suffixIconColor: AppColors.lightTextSecondary,
      ),
    );
  }
}
