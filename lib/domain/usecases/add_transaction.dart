import '../entities/transaction.dart';
import '../repositories/portfolio_repository.dart';

class AddTransaction {
  final PortfolioRepository repository;

  AddTransaction(this.repository);

  Future<void> call(Transaction transaction) async {
    return await repository.addTransaction(transaction);
  }
}
