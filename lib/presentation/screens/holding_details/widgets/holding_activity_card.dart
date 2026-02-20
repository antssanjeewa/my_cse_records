import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/entities/transaction.dart';

class HoldingActivityCard extends StatelessWidget {
  final Transaction transaction;

  const HoldingActivityCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isBuy = t.type == TransactionType.buy;
    final isDiv = t.type == TransactionType.dividend;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDiv
                      ? Colors.blue
                      : (isBuy ? AppColors.primary : AppColors.error))
                  .withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDiv
                  ? Icons.payments
                  : (isBuy
                      ? Icons.add_shopping_cart
                      : Icons.remove_shopping_cart),
              color: isDiv
                  ? Colors.blue
                  : (isBuy ? AppColors.primary : AppColors.error),
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.typeString,
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
                Text(
                  '${AppFormatters.dateOnly.format(t.date)} • ${isDiv ? 'Final Dividend' : 'CDS Account'}',
                  style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isDiv
                    ? AppFormatters.formatCurrency(t.totalPrice)
                    : '${t.qty.toInt()} Shares',
                style: GoogleFonts.inter(
                  color: isDiv ? Colors.blue : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                isDiv
                    ? 'Credited'
                    : '@ ${AppFormatters.formatCurrency(t.unitPrice)}',
                style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
