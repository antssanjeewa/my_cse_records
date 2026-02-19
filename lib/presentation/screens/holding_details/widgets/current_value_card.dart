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
    final marketPrice = h.stock?.lastPrice ?? 0.0;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CURRENT PORTFOLIO VALUE',
                      style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(AppFormatters.formatCurrency(viewModel.marketValue),
                      style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800)),
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
          const SizedBox(height: 16),
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
                'MARKET PRICE: ${AppFormatters.formatCurrency(marketPrice)} (+2.04%)',
                style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
