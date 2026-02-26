import '../entities/holding.dart';
import '../entities/stock.dart';
import '../entities/transaction.dart';
import '../repositories/portfolio_repository.dart';
import '../entities/cash_transaction.dart';
import 'package:uuid/uuid.dart';

class AddTransaction {
  final PortfolioRepository repository;

  AddTransaction(this.repository);

  Future<void> call(Transaction transaction) async {
    // 1. Fetch all necessary data upfront
    final results = await Future.wait([
      repository.getCashBalance(),
      repository.getHoldingByStock(transaction.userId, transaction.stockId),
      repository.getStockById(transaction.stockId),
    ]);

    final double balance = results[0] as double;
    final Holding? existingHolding = results[1] as Holding?;
    final Stock? stock = transaction.stock ?? (results[2] as Stock?);

    // 2. Calculations and Validations
    final ticker = stock?.ticker ?? 'Unknown';

    double newQuantity = transaction.qty;
    double newTotalPrice = transaction.totalPrice;
    double profit = existingHolding?.profit ?? 0;
    double dividend = existingHolding?.dividend ?? 0;

    if (transaction.type == TransactionType.buy) {
      if (balance < transaction.totalPrice) {
        throw Exception('Insufficient balance');
      }

      if (existingHolding != null) {
        newQuantity = existingHolding.quantity + transaction.qty;
        newTotalPrice = existingHolding.totalPrice + transaction.totalPrice;
      }
    } else if (transaction.type == TransactionType.sell) {
      if (existingHolding != null) {
        if (existingHolding.quantity < transaction.qty) {
          throw Exception('Insufficient holdings to sell');
        }

        newQuantity = existingHolding.quantity - transaction.qty;
        final currentValue = existingHolding.avgPrice * transaction.qty;
        newTotalPrice = existingHolding.totalPrice - currentValue;

        profit += (transaction.totalPrice - currentValue);
      } else {
        throw Exception('Cannot sell stock with no existing holdings');
      }
    } else if (transaction.type == TransactionType.dividend) {
      if (existingHolding == null) {
        throw Exception(
            'Cannot receive dividend for stock with no existing holdings');
      }

      dividend += transaction.totalPrice;
      newTotalPrice = existingHolding.totalPrice;
      newQuantity = existingHolding.quantity;
    } else {
      throw Exception('Invalid transaction type');
    }

    // 3. Prepare Writes
    double cashAmount = 0;
    String cashType = '';
    String description = '';

    if (transaction.type == TransactionType.buy) {
      cashAmount = -transaction.totalPrice;
      cashType = 'BUY';
      description = 'Bought $ticker stock';
    } else if (transaction.type == TransactionType.sell) {
      cashAmount = transaction.totalPrice;
      cashType = 'SELL';
      description = 'Sold $ticker stock';
    } else if (transaction.type == TransactionType.dividend) {
      cashAmount = transaction.totalPrice;
      cashType = 'DIVIDEND';
      description = 'Dividend from $ticker';
    }

    // 4. Execute Writes
    // We do them sequentially but quickly as data is ready
    await repository.addTransaction(transaction);

    if (transaction.type != TransactionType.dividend) {
      if (cashAmount != 0) {
        await repository.addCashTransaction(CashTransaction(
          id: const Uuid().v4(),
          userId: transaction.userId,
          amount: cashAmount,
          type: cashType,
          description: description,
          createdAt: transaction.date,
        ));
      }
    }

    await repository.upsertHolding(Holding(
        id: existingHolding?.id ?? '',
        userId: transaction.userId,
        stockId: transaction.stockId,
        avgPrice: newQuantity == 0 ? 0 : newTotalPrice / newQuantity,
        quantity: newQuantity,
        profit: profit,
        dividend: dividend));
  }
}
