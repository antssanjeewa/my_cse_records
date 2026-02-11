import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

/// A custom label widget for form fields with consistent styling
/// Used to label input fields throughout the application
class CustomLabel extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;
  final bool isRequired;

  const CustomLabel({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.only(left: 4),
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          if (isRequired) ...[
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
