import '../entities/holding.dart';
import '../entities/stock.dart';
import '../entities/transaction.dart';

abstract class PortfolioRepository {
  // Stocks
  Future<List<Stock>> getStocks();
  Future<Stock?> getStockById(int id);

  // Holdings
  Future<List<Holding>> getHoldings();
  Future<void> updateHolding(Holding holding);

  // Transactions
  Future<List<Transaction>> getTransactions();
  Future<void> addTransaction(Transaction transaction);
}
