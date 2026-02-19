import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Centralized text theme configuration
/// Defines all text styles used in the Material ThemeData
class AppTextTheme {
  /// Returns the dark theme text theme for the application
  static TextTheme getDarkTextTheme() {
    return TextTheme(
      // Titles
      titleLarge: GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),

      // Display
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),

      // Headlines
      headlineLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),

      // Body text
      bodyLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),

      // Label text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),
    );
  }

  /// Returns the light theme text theme for the application
  static TextTheme getLightTextTheme() {
    return GoogleFonts.interTextTheme(ThemeData.light().textTheme);
  }
}
