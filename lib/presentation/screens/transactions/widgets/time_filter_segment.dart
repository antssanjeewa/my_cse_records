import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class TimeFilterSegment extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeFilterSegment({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.r8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2)
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              )),
        ),
      ),
    );
  }
}
