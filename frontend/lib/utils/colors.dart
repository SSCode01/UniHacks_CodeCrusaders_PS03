import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF6D5DF6);
  static const Color primaryPink = Color(0xFFF48FB1);
  static const Color primaryBlue = Color(0xFF5DA9E9);
  static const Color primaryOrange = Color(0xFFFFB26B);

  static const Color backgroundLight = Color(0xFFF7F6FF);
  static const Color cardWhite = Colors.white;

  static const Color textPrimary = Color(0xFF2E2E3A);
  static const Color textSecondary = Color(0xFF6C6C80);

  static const LinearGradient splashGradient = LinearGradient(
    colors: [
      Color(0xFFF48FB1),
      Color(0xFF6D5DF6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
