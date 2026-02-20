import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/entities/transaction.dart';

class TransactionHistoryItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionHistoryItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isBuy = t.type == TransactionType.buy;
    final isDividend = t.type == TransactionType.dividend;

    Color color;
    if (isDividend) {
      color = AppColors.info;
    } else if (isBuy) {
      color = AppColors.success;
    } else {
      color = AppColors.error;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                      isDividend
                          ? Icons.attach_money
                          : isBuy
                              ? Icons.shopping_cart
                              : Icons.sell,
                      color: Colors.white,
                      size: AppSizes.iconMd),
                ),
                Expanded(child: Container(width: 2, color: AppColors.border)),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.p8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                  border: Border.all(color: color.withAlpha(100))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSizes.r4),
                            ),
                            child: Text(t.typeString.toUpperCase(),
                                style: TextStyle(
                                    color: color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: AppSizes.p4),
                          Text(t.name,
                              style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(t.ticker,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(AppFormatters.dateDetailed.format(t.date),
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p12),
                  Divider(color: color.withAlpha(100), height: 1),
                  const SizedBox(height: AppSizes.p12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('QUANTITY | UNIT PRICE',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
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
                                      text: AppFormatters.formatNumber(t.qty)),
                                  const TextSpan(
                                      text: ' @ ',
                                      style: TextStyle(
                                          color: AppColors.textPrimary)),
                                  TextSpan(text: t.unitPrice.toString()),
                                ]),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('TOTAL VALUE',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(AppFormatters.formatCurrency(t.totalPrice),
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
