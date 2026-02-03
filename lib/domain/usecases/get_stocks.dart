import '../entities/stock.dart';
import '../repositories/portfolio_repository.dart';

class GetStocks {
  final PortfolioRepository repository;

  GetStocks(this.repository);

  Future<List<Stock>> call() async {
    return await repository.getStocks();
  }
}
