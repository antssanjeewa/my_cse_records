import '../entities/transaction.dart';
import '../repositories/portfolio_repository.dart';

class GetTransactions {
  final PortfolioRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call({
    int? stockId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    return await repository.getTransactions(
      stockId: stockId,
      type: type,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }
}
