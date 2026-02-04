import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

/// A custom label widget for form fields with consistent styling
class CustomLabel extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;

  const CustomLabel({
    super.key,
    required this.text,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
