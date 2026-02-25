import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/entities/holding.dart';

class PositionSummaryCard extends StatelessWidget {
  final Holding holding;

  const PositionSummaryCard({
    super.key,
    required this.holding,
  });

  @override
  Widget build(BuildContext context) {
    final h = holding;
    final isPositive = h.profit >= 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('POSITION SUMMARY',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2)),
                const SizedBox(height: AppSizes.p20),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildSummaryItem(
                          'Current P/L',
                          (isPositive ? '+' : '') +
                              AppFormatters.formatCurrency(h.profit),
                          color:
                              isPositive ? AppColors.success : AppColors.error),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Expanded(
                      flex: 2,
                      child: _buildSummaryItem('Average Cost',
                          AppFormatters.formatCurrency(h.avgPrice)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p20),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildSummaryItem('Invested Value',
                          AppFormatters.formatCurrency(h.totalPrice)),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Expanded(
                      flex: 2,
                      child: _buildSummaryItem('Total Shares',
                          AppFormatters.formatNumber(h.quantity)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.normal)),
        const SizedBox(height: 2),
        Text(value,
            style: GoogleFonts.inter(
                color: color ?? AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
