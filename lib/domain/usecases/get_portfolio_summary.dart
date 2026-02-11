import '../entities/portfolio_summary.dart';
import '../repositories/portfolio_repository.dart';

class GetPortfolioSummary {
  final PortfolioRepository repository;

  GetPortfolioSummary(this.repository);

  Future<PortfolioSummary> call() async {
    final holdings = await repository.getHoldings();

    double totalValue = 0;
    double totalProfit = 0;

    for (var h in holdings) {
      totalValue += h.value;
      totalProfit += h.profit;
    }

    double load = 15200.50;
    final cashBalance = await repository.getCashBalance();

    return PortfolioSummary(
      totalValue: totalValue,
      totalProfit: totalProfit,
      load: load,
      cashBalance: cashBalance,
      holdings: holdings,
    );
  }
}
