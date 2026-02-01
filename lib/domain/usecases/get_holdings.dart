import '../entities/holding.dart';
import '../repositories/portfolio_repository.dart';

class GetHoldings {
  final PortfolioRepository repository;

  GetHoldings(this.repository);

  Future<List<Holding>> call() async {
    return await repository.getHoldings();
  }
}
