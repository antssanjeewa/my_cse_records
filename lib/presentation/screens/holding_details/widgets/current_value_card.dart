import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../viewmodels/holding_details_viewmodel.dart';

class CurrentValueCard extends StatelessWidget {
  final HoldingDetailsViewModel viewModel;

  const CurrentValueCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final h = viewModel.holding;
    final dividend = h.dividend;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stock Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                h.name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(h.startYear)
            ],
          ),
          const SizedBox(height: AppSizes.p4),
          // Sector Name
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(getSectorIcon(h.sector),
                  size: 14, color: AppColors.textPrimary),
              const SizedBox(width: 6),
              Text(
                h.sector.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withAlpha(15),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppFormatters.formatCurrency(viewModel.marketValue),
                      style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                ),
                child: Text(
                  '${viewModel.concentration.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'DIVIDEND:',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(width: 8),
              Text(
                AppFormatters.formatCurrency(dividend),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
