import 'package:flutter/material.dart';

/// Single cohesive palette for the whole app — warm amber/ink, evokes a
/// premium neighborhood store rather than generic Material blue.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFE8792B);
  static const Color primaryDark = Color(0xFFC85F1A);
  static const Color primaryLight = Color(0xFFFFE4C7);

  static const Color secondary = Color(0xFF1F3A3D);
  static const Color accent = Color(0xFF2FA88A);

  static const Color background = Color(0xFFFBF8F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3EDE4);

  static const Color textPrimary = Color(0xFF241C15);
  static const Color textSecondary = Color(0xFF7A6F63);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF2FA88A);
  static const Color error = Color(0xFFD64545);
  static const Color warning = Color(0xFFE0A93A);

  static const Color divider = Color(0xFFE9E1D6);
  static const Color shimmerBase = Color(0xFFEDE6DB);
  static const Color shimmerHighlight = Color(0xFFF8F4EC);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}
