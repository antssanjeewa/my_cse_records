import '../entities/portfolio_summary.dart';
import '../repositories/portfolio_repository.dart';

class GetPortfolioSummary {
  final PortfolioRepository repository;

  GetPortfolioSummary(this.repository);

  Future<PortfolioSummary> call() async {
    final holdings = await repository.getHoldings();

    double totalValue = 0;
    double totalProfit = 0;
    double totalDividends = 0;

    for (var h in holdings) {
      totalValue += h.totalPrice;
      totalProfit += h.profit;
      totalDividends += h.dividend;
    }

    final cashBalance = await repository.getCashBalance();
    const double load = 15200.50;

    return PortfolioSummary(
      totalValue: totalValue,
      totalProfit: totalProfit,
      totalDividends: totalDividends,
      load: load,
      cashBalance: cashBalance,
      holdings: holdings,
    );
  }
}
