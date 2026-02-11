import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/constants.dart';

/// A custom date picker field with consistent styling
/// Provides a consistent date selection experience across the app
class CustomDateField extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateFormat;
  final double height;
  final String? hintText;
  final String? labelText;

  const CustomDateField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'yyyy-MM-dd',
    this.height = 56,
    this.hintText,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.surface,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: AppSizes.p12),
            Expanded(
              child: Text(
                DateFormat(dateFormat).format(selectedDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
