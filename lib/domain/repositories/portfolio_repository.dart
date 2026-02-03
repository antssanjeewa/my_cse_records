import '../entities/holding.dart';
import '../entities/stock.dart';
import '../entities/transaction.dart';
import '../entities/cash_transaction.dart';

abstract class PortfolioRepository {
  // Stocks
  Future<List<Stock>> getStocks();
  Future<Stock?> getStockById(int id);
  Future<Stock> addStock({
    required String ticker,
    required String name,
    String? sector,
    required double lastPrice,
  });
  Future<void> updateStock({
    required int stockId,
    String? sector,
    required double lastPrice,
  });
  Future<void> deleteStock(int stockId);

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

  // Cash Management
  Future<List<CashTransaction>> getCashTransactions();
  Future<void> addCashTransaction(CashTransaction transaction);
  Future<double> getCashBalance();
}
