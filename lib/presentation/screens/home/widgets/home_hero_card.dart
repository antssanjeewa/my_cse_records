import 'package:flutter/material.dart';

import '../../../../domain/entities/portfolio_summary.dart';
import '../../../widgets/summary_card.dart';

class HomeHeroCard extends StatelessWidget {
  final PortfolioSummary summary;

  const HomeHeroCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return SummaryCard(
      title: 'Net Worth',
      mainValue: summary.netWorth,
      leftLabel: 'Portfolio value',
      leftValue: summary.totalValue,
      rightLabel: 'Available balance',
      rightValue: summary.cashBalance,
    );
  }
}
