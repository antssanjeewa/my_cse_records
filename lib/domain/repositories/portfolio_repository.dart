import '../entities/holding.dart';

abstract class PortfolioRepository {
  Future<List<Holding>> getHoldings();
}
