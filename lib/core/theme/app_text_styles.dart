import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized text styles for the application
/// This eliminates duplication and ensures consistency across the UI
class AppTextStyles {
  // Headlines
  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  // Titles
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  // Body text
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      );

  // Display/Label text
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: Colors.white,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: Colors.white,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: Colors.white,
      );

  // Hint/Secondary text
  static TextStyle get hintText => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey[400],
      );

  static TextStyle get captionText => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Colors.grey[500],
      );

  // Subtitle styles
  static TextStyle get subtitle => GoogleFonts.inter(
        fontSize: 16,
        color: Colors.grey[400],
      );

  static TextStyle get subtitleSmall => GoogleFonts.inter(
        fontSize: 12,
        color: Colors.grey[500],
      );

  // Market status styles
  static TextStyle get marketStatusOpen => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      );

  static TextStyle get marketTime => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );
}
