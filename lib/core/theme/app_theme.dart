import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'theme_provider.dart';

/// AppTheme builds dynamic Material 3 themes supporting 5 curated color palettes
/// in both Dark (AMOLED Slate) and Light (Clean Crisp White) modes.
class AppTheme {
  AppTheme._();

  static Color getPrimaryColor(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.amber:
        return const Color(0xFFF59E0B);
      case AppColorTheme.blue:
        return const Color(0xFF2563EB);
      case AppColorTheme.green:
        return const Color(0xFF10B981);
      case AppColorTheme.red:
        return const Color(0xFFEF4444);
      case AppColorTheme.purple:
        return const Color(0xFF8B5CF6);
    }
  }

  static Color getPrimaryColorDark(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.amber:
        return const Color(0xFFD97706);
      case AppColorTheme.blue:
        return const Color(0xFF1D4ED8);
      case AppColorTheme.green:
        return const Color(0xFF059669);
      case AppColorTheme.red:
        return const Color(0xFFDC2626);
      case AppColorTheme.purple:
        return const Color(0xFF7C3AED);
    }
  }

  static Color getSecondaryColor(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.amber:
        return const Color(0xFF06B6D4);
      case AppColorTheme.blue:
        return const Color(0xFFF59E0B);
      case AppColorTheme.green:
        return const Color(0xFF06B6D4);
      case AppColorTheme.red:
        return const Color(0xFFF59E0B);
      case AppColorTheme.purple:
        return const Color(0xFF06B6D4);
    }
  }

  /// Builds a complete, cohesive ThemeData for any chosen color theme & brightness
  static ThemeData buildTheme({
    required AppColorTheme colorTheme,
    required bool isDark,
  }) {
    final primary = getPrimaryColor(colorTheme);
    final secondary = getSecondaryColor(colorTheme);

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: primary,
            onPrimary: Colors.black,
            secondary: secondary,
            onSecondary: Colors.black,
            surface: card,
            onSurface: textPrimary,
            error: AppColors.emergencyRed,
            onError: Colors.white,
          )
        : ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            secondary: secondary,
            onSecondary: Colors.white,
            surface: card,
            onSurface: textPrimary,
            error: AppColors.emergencyRed,
            onError: Colors.white,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: bg,
      colorScheme: colorScheme,
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          fontSize: 26,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 14,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 12.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.emergencyRed),
        ),
        hintStyle: TextStyle(
          color: textSecondary.withOpacity(0.7),
          fontSize: 13.5,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: card,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
      ),
    );
  }

  // Default convenience getters
  static ThemeData get darkTheme => buildTheme(colorTheme: AppColorTheme.blue, isDark: true);
  static ThemeData get lightTheme => buildTheme(colorTheme: AppColorTheme.blue, isDark: false);
}
