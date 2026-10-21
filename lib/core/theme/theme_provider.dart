import 'package:flutter/material.dart';

enum AppColorTheme {
  amber,   // Electric Amber (#F59E0B)
  blue,    // Royal Electric Blue (#2563EB)
  green,   // Emerald Power (#10B981)
  red,     // Crimson Energy (#EF4444)
  purple,  // Modern Violet (#8B5CF6)
}

/// Manages app theme mode (Light, Dark, System) and primary accent color palette.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  AppColorTheme _colorTheme = AppColorTheme.blue;

  ThemeMode get themeMode => _themeMode;
  AppColorTheme get colorTheme => _colorTheme;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Color get primaryColor {
    switch (_colorTheme) {
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

  Color get primaryColorDark {
    switch (_colorTheme) {
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

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void setColorTheme(AppColorTheme theme) {
    if (_colorTheme != theme) {
      _colorTheme = theme;
      notifyListeners();
    }
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  String colorThemeName(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.amber:
        return 'Electric Amber';
      case AppColorTheme.blue:
        return 'Royal Blue';
      case AppColorTheme.green:
        return 'Emerald Green';
      case AppColorTheme.red:
        return 'Crimson Power';
      case AppColorTheme.purple:
        return 'Modern Violet';
    }
  }
}
