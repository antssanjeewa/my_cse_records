import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF5369D4);
  static const Color primaryDark = Color(0xFF0B162C);

  // Backgrounds
  static const Color background = Color(0xFF101322);
  static const Color backgroundGradientEnd = Color(0xFF0B101E);
  static const Color surface = Color(0xFF191E33);
  static const Color surfaceLight = Color(0xFF232948);

  // Borders & Dividers
  static const Color border = Color(0xFF323B67);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF929BC9); // Slate blueish grey
  static const Color textHint = Colors.white54; // or use withOpacity/withValues

  // Functional Colors
  static const Color success = Colors.greenAccent;
  static const Color error = Colors.redAccent;
  static const Color errorBg = Colors.red;
  static const Color successBg = Colors.green;
  static const Color info = Colors.blueAccent;
  static const Color warn = Colors.orangeAccent;

  // Overlays
  static final Color overlayDark = Colors.black.withValues(alpha: 0.5);

  // Transparency helper (if needed for older logic, but try using direct colors)
  static final Color primaryLowOpacity = primary.withValues(alpha: 0.1);
}
