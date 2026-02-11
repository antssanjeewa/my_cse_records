import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/routing/pages.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../viewmodels/home_viewmodel.dart';

class HomeRecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const HomeRecentTransactions({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Activity',
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            if (transactions.isNotEmpty)
              GestureDetector(
                onTap: () => Pages.transactions.go(context),
                child: Text(AppText.viewAll,
                    style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.p12),
        if (transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSizes.p20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.r16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text('No recent transactions',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ),
          )
        else
          ...transactions.map((t) {
            final summary = context.read<HomeViewModel>().summary;
            if (summary == null) return const SizedBox();

            // Find the parent holding for this transaction to allow navigation
            final parentHolding =
                summary.holdings.firstWhere((h) => h.stockId == t.stockId);

            return GestureDetector(
              onTap: () {
                if (parentHolding.id.isNotEmpty) {
                  Pages.holdingDetails.push(context, extra: {
                    'holding': parentHolding,
                    'totalValue': summary.totalValue + summary.totalProfit,
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: AppSizes.p8),
                padding: const EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (t.type == TransactionType.buy
                                ? AppColors.primary
                                : t.type == TransactionType.sell
                                    ? AppColors.error
                                    : AppColors.success)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                      ),
                      child: Icon(
                        t.type == TransactionType.buy
                            ? Icons.add_chart
                            : t.type == TransactionType.sell
                                ? Icons.show_chart
                                : Icons.account_balance_wallet,
                        color: t.type == TransactionType.buy
                            ? AppColors.primary
                            : t.type == TransactionType.sell
                                ? AppColors.error
                                : AppColors.success,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.ticker.split('.')[0],
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          Text(
                              '${t.typeString} • ${AppFormatters.dateOnly.format(t.date)}',
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(t.type == TransactionType.sell || t.type == TransactionType.dividend) ? '+' : '-'} ${AppFormatters.formatCurrency(t.total_price)}',
                          style: TextStyle(
                            color: (t.type == TransactionType.sell ||
                                    t.type == TransactionType.dividend)
                                ? AppColors.success
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${t.qty.toInt()} Shares',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
