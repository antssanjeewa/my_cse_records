import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/holding.dart';

class HoldingCard extends StatelessWidget {
  final Holding holding;
  final VoidCallback? onTap;

  const HoldingCard({
    super.key,
    required this.holding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var profit = holding.profit;
    final profitPct = holding.profitPercent;
    final activeColor =
        holding.quantity > 0 ? AppColors.primary : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.p16),
        padding: const EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color:
              holding.quantity > 0 ? AppColors.surfaceLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(color: activeColor),
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(holding.sector,
                        style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0)),
                    Text(holding.ticker,
                        style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(holding.name,
                        style: GoogleFonts.inter(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(AppSizes.r12)),
                  child: Icon(getSectorIcon(holding.sector),
                      color: Colors.white54, size: AppSizes.iconMd),
                )
              ],
            ),
            const SizedBox(height: AppSizes.p12),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: AppSizes.p12),
            // Middle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('QUANTITY | UNIT PRICE',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(
                                text: AppFormatters.formatNumber(
                                    holding.quantity)),
                            const TextSpan(
                                text: ' @ ',
                                style: TextStyle(color: Colors.grey)),
                            TextSpan(text: holding.avgPrice.toStringAsFixed(2)),
                          ]),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('TOTAL COST',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(AppFormatters.formatCurrency(holding.totalPrice),
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                )
              ],
            ),
            const SizedBox(height: AppSizes.p12),
            // Bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('UNREALIZED P/L',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          (profit < 0 ? '' : '+') +
                              AppFormatters.formatCurrency(profit),
                          style: TextStyle(
                              color: profit < 0
                                  ? AppColors.error
                                  : AppColors.success,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: AppSizes.p8),
                        Row(
                          children: [
                            Icon(
                                profit < 0
                                    ? Icons.trending_down
                                    : Icons.trending_up,
                                color: profit < 0
                                    ? AppColors.error
                                    : AppColors.success,
                                size: 16),
                            const SizedBox(width: AppSizes.p4),
                            Text('${profitPct.toStringAsFixed(2)}%',
                                style: TextStyle(
                                    color: profit < 0
                                        ? AppColors.error
                                        : AppColors.success,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('TOTAL DIVIDENDS',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(AppFormatters.formatCurrency(holding.dividend),
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
