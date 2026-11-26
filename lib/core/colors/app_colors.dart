import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors matching Home Dashboard Theme
  static const Color primaryPurple = Color(0xFF555ABC); // Home Dashboard Primary Blue
  static const Color secondaryPurple = Color(0xFF8B8ED3); // Home Dashboard Light Accent
  static const Color accentPurple = Color(0xFF555ABC);

  // Design Specific Colors
  static const Color loginBackground = Color(0xFFFAFBFD);
  static const Color loginAccent = Color(0xFFC9DDE7);
  static const Color loginButtonBlue = Color(0xFF555ABC);
  static const Color loginBadgeBlue = Color(0xFF74A4D1);

  // SFA Specific Colors
  static const Color sfaBlue = Color(0xFF555ABC);
  static const Color sfaLightBlue = Color(0xFFE1F1F8);
  static const Color sfaTextGray = Color(0xFF757575);
  static const Color sfaIconBoxBlue = Color(0xFF555ABC);
  static const Color sfaSendOtpBlue = Color(0xFF87D5F2);

  // Background & Surfaces
  static const Color background = Color(0xFFFAFBFD);
  static const Color surfaceWhite = Colors.white;
  static const Color fieldBackground = Color(0xFFF1F5F9);

  // Specific UI Elements
  static const Color filterBlue = Color(0xFF555ABC);
  static const Color lightBlueBackground = Color(0xFFEEF2FF);

  // Accents
  static const Color primary = Color(0xFF555ABC);
  static const Color secondary = Color(0xFF94A3B8);
  static const Color tealAccent = Color(0xFF2DD4BF);

  // Text
  static const Color textPrimary = Color(0x57031A40);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color white = Colors.white;

  // Metric Tab Colors
  static const Color metricBlue = Color(0xFF0056D2);
  static const Color metricBlueBg = Color(0xFFE7F0FF);

  static const Color metricGreen = Color(0xFF1B873F);
  static const Color metricGreenBg = Color(0xFFE9F5ED);

  static const Color metricTeal = Color(0xFF0A5D67);
  static const Color metricTealBg = Color(0xFFE5F3F5);

  static const Color metricPink = Color(0xFFD32F2F);
  static const Color metricPinkBg = Color(0xFFFDEAEA);

  // Gradients matching Home Dashboard Header
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF17193F), Color(0xFF555ABC), Color(0xFF8B8ED3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
