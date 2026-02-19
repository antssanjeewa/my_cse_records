import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/constants.dart';
import 'text_theme.dart';
import 'input_decoration_theme.dart';

class AppTheme {
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTextTheme.getDarkTextTheme(),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.surface,
      ),
      inputDecorationTheme:
          AppInputDecorationTheme.getDarkInputDecorationTheme(),
      useMaterial3: true,
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      textTheme: AppTextTheme.getLightTextTheme(),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: Colors.white,
        tertiary: Color(0xFF1337EC),
        onSurface: Color(0xFF1A1A1A),
        onPrimary: Colors.white,
      ),
      inputDecorationTheme:
          AppInputDecorationTheme.getLightInputDecorationTheme(),
      useMaterial3: true,
    );
  }
}
