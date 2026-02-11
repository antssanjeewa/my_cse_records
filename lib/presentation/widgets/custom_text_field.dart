import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

/// A custom text field widget with consistent styling
/// Ensures all text fields in the app have uniform appearance and behavior
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? prefixText;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final double height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final int maxLines;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.height = 56,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.obscureText = false,
    this.textInputAction,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        maxLines: obscureText ? 1 : maxLines,
        minLines: 1,
        obscureText: obscureText,
        maxLength: maxLength,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textHint,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: prefixIcon,
          prefixText: prefixText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p12,
          ),
          counterText: '',
        ),
      ),
    );
  }
}
