import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

/// A custom text field widget with consistent styling
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? prefixText;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final double? height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final int maxLine;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.height,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.maxLine = 1,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        maxLines: maxLine,
        keyboardType: keyboardType,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: prefixIcon,
          prefixText: prefixText,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
        ),
      ),
    );
  }
}
