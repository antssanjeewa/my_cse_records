import '../entities/holding.dart';
import '../repositories/portfolio_repository.dart';

class GetHoldingByStock {
  final PortfolioRepository repository;

  GetHoldingByStock(this.repository);

  Future<Holding?> call(String userId, int stockId) async {
    return await repository.getHoldingByStock(userId, stockId);
  }
}
