import 'holding.dart';

class PortfolioSummary {
  final double totalValue;
  final double totalProfit;
  final double load;
  final List<Holding> holdings; // Added this

  PortfolioSummary({
    required this.totalValue,
    required this.totalProfit,
    required this.load,
    required this.holdings,
  });

  double get totalProfitPercent =>
      totalValue == 0 ? 0 : (totalProfit / (totalValue - totalProfit)) * 100;
}
