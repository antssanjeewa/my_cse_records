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
  Future<void> upsertHolding(Holding holding);
  Future<Holding?> getHoldingByStock(String userId, int stockId);

  // Transactions
  Future<List<Transaction>> getTransactions({
    int? stockId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });
  Future<void> addTransaction(Transaction transaction);
}
