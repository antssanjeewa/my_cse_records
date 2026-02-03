import '../../domain/entities/holding.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/supabase_datasource.dart';
import '../models/transaction_model.dart';
import '../models/holding_model.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final RemoteDataSource remoteDataSource;

  PortfolioRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Stock>> getStocks() async {
    return await remoteDataSource.getStocks();
  }

  @override
  Future<Stock?> getStockById(int id) async {
    final stocks = await remoteDataSource.getStocks();
    try {
      return stocks.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Holding>> getHoldings() async {
    return await remoteDataSource.getHoldings();
  }

  @override
  Future<void> updateHolding(Holding holding) async {
    await remoteDataSource.updateHolding(HoldingModel(
      id: holding.id,
      userId: holding.userId,
      stockId: holding.stockId,
      avgPrice: holding.avgPrice,
      quantity: holding.quantity,
    ));
  }

  @override
  Future<void> upsertHolding(Holding holding) async {
    await remoteDataSource.upsertHolding(HoldingModel(
      id: holding.id,
      userId: holding.userId,
      stockId: holding.stockId,
      avgPrice: holding.avgPrice,
      quantity: holding.quantity,
    ));
  }

  @override
  Future<Holding?> getHoldingByStock(String userId, int stockId) async {
    return await remoteDataSource.getHoldingByStock(userId, stockId);
  }

  @override
  Future<List<Transaction>> getTransactions({
    int? stockId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    return await remoteDataSource.getTransactions(
      stockId: stockId,
      type: type,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await remoteDataSource.addTransaction(TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      stockId: transaction.stockId,
      type: transaction.type,
      qty: transaction.qty,
      price: transaction.price,
      date: transaction.date,
    ));
  }
}
