import 'package:flutter/material.dart';

/// Centralized color palette for Zemtro Electrician
/// Combines electric amber/yellow (power, energy) with high-tech slate/navy and emergency colors.
class AppColors {
  AppColors._();

  // Primary Electric Brand Colors
  static const Color primaryAmber = Color(0xFFF59E0B);      // Vibrant Electric Amber
  static const Color primaryAmberLight = Color(0xFFFBBF24); // Light Amber Glow
  static const Color primaryAmberDark = Color(0xFFD97706);  // Deep Amber Gold

  // Secondary High-Tech Accents
  static const Color electricCyan = Color(0xFF06B6D4);     // High-voltage Cyan
  static const Color electricBlue = Color(0xFF2563EB);     // Trust Blue
  static const Color safetyGreen = Color(0xFF10B981);      // Verified / Active / Safe
  static const Color emergencyRed = Color(0xFFEF4444);      // 24/7 Breakdown Emergency
  static const Color urgentOrange = Color(0xFFF97316);      // Urgent status

  // Dark Theme Palette (AMOLED / Slate Navy)
  static const Color darkBg = Color(0xFF0B0F19);           // Midnight Slate
  static const Color darkCard = Color(0xFF131C2E);         // Elevated Dark Card
  static const Color darkCardHover = Color(0xFF1E293B);    // Border/Hover
  static const Color darkBorder = Color(0xFF223049);       // Subtle divider/border
  static const Color darkTextPrimary = Color(0xFFF8FAFC);  // Bright off-white
  static const Color darkTextSecondary = Color(0xFF94A3B8);// Slate gray

  // Light Theme Palette (Clean, Modern, Trustworthy)
  static const Color lightBg = Color(0xFFF8FAFC);          // Crisp Slate Gray-50
  static const Color lightCard = Color(0xFFFFFFFF);        // Pure White Card
  static const Color lightCardSubtle = Color(0xFFF1F5F9);  // Slate 100
  static const Color lightBorder = Color(0xFFE2E8F0);      // Slate 200
  static const Color lightTextPrimary = Color(0xFF0F172A); // Dark Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500

  // Gradients
  static const LinearGradient electricAmberGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF131C2E), Color(0xFF0D1424)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanElectricGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
