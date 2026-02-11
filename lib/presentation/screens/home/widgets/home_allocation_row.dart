import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../domain/entities/holding.dart';
import '../../../../domain/entities/portfolio_summary.dart';
import 'home_allocation_card.dart';

class HomeAllocationRow extends StatelessWidget {
  final PortfolioSummary summary;

  const HomeAllocationRow({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HomeAllocationCard(
            title: 'Assets',
            sections: [
              ChartSectionData(
                value: summary.totalValue,
                color: AppColors.primary,
                label: 'Stocks',
              ),
              ChartSectionData(
                value: summary.cashBalance,
                color: Colors.orange,
                label: 'Cash',
              ),
              ChartSectionData(
                value: summary.totalDividends,
                color: Colors.green,
                label: 'Div',
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.p12),
        Expanded(
          child: HomeAllocationCard(
            title: 'Stocks',
            sections: _getStockSections(summary.holdings),
          ),
        ),
      ],
    );
  }

  List<ChartSectionData> _getStockSections(List<Holding> holdings) {
    if (holdings.isEmpty) return [];
    final sorted = List<Holding>.from(holdings)
      ..sort((a, b) => b.totalPrice.compareTo(a.totalPrice));

    final top4 = sorted.take(4).toList();
    final otherVal = sorted.length > 4
        ? sorted.skip(4).fold(0.0, (sum, h) => sum + h.totalPrice)
        : 0.0;

    final palette = [
      AppColors.primary,
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
    ];

    final List<ChartSectionData> sections = [];
    for (int i = 0; i < top4.length; i++) {
      sections.add(ChartSectionData(
        value: top4[i].totalPrice,
        color: palette[i],
        label: top4[i].ticker.split('.')[0],
      ));
    }

    if (otherVal > 0) {
      sections.add(ChartSectionData(
        value: otherVal,
        color: Colors.grey.withValues(alpha: 0.3),
        label: 'Other',
      ));
    }

    return sections;
  }
}
