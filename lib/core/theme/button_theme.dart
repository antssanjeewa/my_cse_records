import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Centralized button styles for the application
/// Defines all button styling used throughout the app
class AppButtonStyles {
  // Primary button style - Full width CTA button
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
        ),
        elevation: 4,
        shadowColor: AppColors.primary.withValues(alpha: 0.2),
      );

  // Secondary button style - Full width secondary button with border
  static ButtonStyle get secondaryButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          side: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      );

  // Compact button style - Smaller inline button
  static ButtonStyle get compactButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r8),
        ),
      );

  // Danger button style - For destructive actions
  static ButtonStyle get dangerButton => ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
        ),
      );

  // Success button style - For positive actions
  static ButtonStyle get successButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
        ),
      );

  // Outline button style - For secondary actions with outline
  static ButtonStyle get outlineButton => ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 56),
        side: const BorderSide(color: AppColors.primary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
        ),
      );

  // Text button style - Minimal button without background
  static TextStyle get textButtonStyle => TextStyle(
        color: AppColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
}
