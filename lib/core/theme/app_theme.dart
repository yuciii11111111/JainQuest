import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================================
// Premium Dark Theme Colors
// ============================================================================

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color backgroundBase = Color(0xFF0E0B22);
  static const Color backgroundCard = Color(0xFF1D1938);
  static const Color backgroundElevated = Color(0xFF2A2351);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFC7BEEA);
  static const Color textMuted = Color(0xFF8C82B6);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF6F5BFA), // Electric Lavender
    Color(0xFF5B74FF), // Periwinkle
    Color(0xFF4354D6), // Deep Indigo
  ];

  static const List<Color> accentGradient = [
    Color(0xFFC084FC), // Soft Violet
    Color(0xFFD977FF), // Orchid
    Color(0xFFF472D0), // Neon Pink
  ];

  static const List<Color> successGradient = [
    Color(0xFF34D399), // Emerald
    Color(0xFF10B981), // Green
    Color(0xFF059669), // Deep Green
  ];

  static const List<Color> warmGradient = [
    Color(0xFFFBBF24), // Amber
    Color(0xFFF59E0B), // Orange
    Color(0xFFD97706), // Deep Orange
  ];

  // Solid Accents
  static const Color primary = Color(0xFF6F5BFA);
  static const Color secondary = Color(0xFFC084FC);
  static const Color highlight = Color(0xFF7DD3FC);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color achievementGold = Color(0xFFFFD700);

  // Glassmorphism
  static const Color glassOverlay = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x4DFFFFFF);
  static const double glassBlur = 24.0;

  // Light Mode (Optional)
  static const Color lightBackground = Color(0xFFF6F4EF);
  static const Color lightCard = Color(0xFFFCFBF8);
  static const Color lightElevated = Color(0xFFF0EEE7);
  static const Color lightTextPrimary = Color(0xFF1E1B16);
  static const Color lightTextSecondary = Color(0xFF5E564B);
  static const Color lightTextMuted = Color(0xFF8A8174);
  static const Color lightBorder = Color(0xFFE3DED2);
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

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundBase,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.backgroundCard,
        surfaceVariant: AppColors.backgroundElevated,
        outline: AppColors.glassBorder,
        onSurfaceVariant: AppColors.textSecondary,
        error: AppColors.danger,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),

      // Typography
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.nunito(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.25,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.nunito(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        headlineLarge: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.35,
        ),
        headlineSmall: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.45,
        ),
        titleSmall: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          height: 1.45,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.4,
        ),
        labelSmall: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          letterSpacing: 0.3,
        ),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
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
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
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
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightCard,
        surfaceVariant: AppColors.lightElevated,
        outline: AppColors.lightBorder,
        error: AppColors.danger,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.lightTextPrimary,
        onSurfaceVariant: AppColors.lightTextSecondary,
        onError: AppColors.textPrimary,
        onBackground: AppColors.lightTextPrimary,
      ),

      // Typography
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.lightTextPrimary,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.nunito(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.lightTextPrimary,
          height: 1.25,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.nunito(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.lightTextPrimary,
          height: 1.3,
        ),
        headlineLarge: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
          height: 1.35,
        ),
        headlineSmall: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
          height: 1.4,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
          height: 1.45,
        ),
        titleSmall: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextSecondary,
          height: 1.45,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextSecondary,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextSecondary,
          letterSpacing: 0.4,
        ),
        labelSmall: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextSecondary,
          letterSpacing: 0.3,
        ),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
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
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
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
    );
  }
}
