import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Centralized input decoration theme configuration
/// Defines the styling for all input fields (TextFormField, TextField, etc.)
class AppInputDecorationTheme {
  /// Returns the dark theme input decoration theme
  static InputDecorationTheme getDarkInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error, width: 2),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
    );
  }

  /// Returns the light theme input decoration theme
  static InputDecorationTheme getLightInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      hintStyle: const TextStyle(color: Color(0xFF999999)),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error, width: 2),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
    );
  }
}
