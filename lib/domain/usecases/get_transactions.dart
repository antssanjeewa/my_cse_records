import '../entities/transaction.dart';
import '../repositories/portfolio_repository.dart';

class GetTransactions {
  final PortfolioRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call() async {
    return await repository.getTransactions();
  }
}
