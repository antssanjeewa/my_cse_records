import 'package:flutter/material.dart';

/// A custom text field widget with consistent styling
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? prefixText;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
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
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.maxLine = 1,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      maxLines: maxLine,
      validator: validator,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefixIcon,
          prefixText: prefixText,
          suffixIcon: suffixIcon),
    );
  }
}
