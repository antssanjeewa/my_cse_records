import 'holding.dart';

class PortfolioSummary {
  final double totalValue;
  final double totalProfit;
  final double totalDividends;
  final double load;
  final double cashBalance;
  final List<Holding> holdings;

  PortfolioSummary({
    required this.totalValue,
    required this.totalProfit,
    required this.totalDividends,
    required this.load,
    required this.cashBalance,
    required this.holdings,
  });

  double get netWorth => totalValue + cashBalance;

  double get totalProfitPercent {
    final costBasis = totalValue - totalProfit;
    if (costBasis <= 0) return 0;
    return (totalProfit / costBasis) * 100;
  }
}
