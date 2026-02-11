import 'holding.dart';

class PortfolioSummary {
  final double totalValue;
  final double totalProfit;
  final double load;
  final double cashBalance;
  final List<Holding> holdings;

  PortfolioSummary({
    required this.totalValue,
    required this.totalProfit,
    required this.load,
    required this.cashBalance,
    required this.holdings,
  });

  double get netWorth => totalValue + cashBalance;

  double get totalProfitPercent =>
      totalValue == 0 ? 0 : (totalProfit / (totalValue - totalProfit)) * 100;
}
