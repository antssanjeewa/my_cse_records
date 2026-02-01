import '../../domain/entities/holding.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/local_datasource.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final LocalDataSource localDataSource;

  PortfolioRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Holding>> getHoldings() async {
    return await localDataSource.getHoldings();
  }
}
