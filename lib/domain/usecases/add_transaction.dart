import '../entities/holding.dart';
import '../entities/transaction.dart';
import '../repositories/portfolio_repository.dart';
import '../entities/cash_transaction.dart';
import 'package:uuid/uuid.dart';

class AddTransaction {
  final PortfolioRepository repository;

  AddTransaction(this.repository);

  Future<void> call(Transaction transaction) async {
    final balance = await repository.getCashBalance();

    final existingHolding = await repository.getHoldingByStock(
      transaction.userId,
      transaction.stockId,
    );

    double newQuantity = transaction.qty;
    double newTotalPrice = transaction.total_price;
    double profit = existingHolding?.profit ?? 0;
    double dividend = existingHolding?.dividend ?? 0;

    if (transaction.type == TransactionType.buy) {
      if (balance < transaction.total_price) {
        throw Exception('Insufficient balance');
      }

      if (existingHolding != null) {
        newQuantity = existingHolding.quantity + transaction.qty;
        newTotalPrice = existingHolding.totalPrice + transaction.total_price;
      }
    } else if (transaction.type == TransactionType.sell) {
      if (existingHolding != null) {
        if (existingHolding.quantity < transaction.qty) {
          throw Exception('Insufficient holdings to sell');
        }

        newQuantity = existingHolding.quantity - transaction.qty;
        final currentValue = existingHolding.avgPrice * transaction.qty;
        newTotalPrice = existingHolding.totalPrice - currentValue;

        profit += (transaction.total_price - currentValue);
      } else {
        throw Exception('Cannot sell stock with no existing holdings');
      }
    } else if (transaction.type == TransactionType.dividend) {
      if (existingHolding == null) {
        throw Exception(
            'Cannot receive dividend for stock with no existing holdings');
      }

      dividend += transaction.total_price;
      newTotalPrice = existingHolding.totalPrice;
      newQuantity = existingHolding.quantity;
    } else {
      throw Exception('Invalid transaction type');
    }

    await repository.addTransaction(transaction);

    // Get stock info for description
    final stock = await repository.getStockById(transaction.stockId);
    final ticker = stock?.ticker ?? 'Unknown';

    // Add corresponding cash transaction
    double cashAmount = 0;
    String cashType = '';
    String description = '';

    if (transaction.type == TransactionType.buy) {
      cashAmount = -transaction.total_price;
      cashType = 'BUY';
      description = 'Bought $ticker stock';
    } else if (transaction.type == TransactionType.sell) {
      cashAmount = transaction.total_price;
      cashType = 'SELL';
      description = 'Sold $ticker stock';
    } else if (transaction.type == TransactionType.dividend) {
      cashAmount = transaction.total_price;
      cashType = 'DIVIDEND';
      description = 'Dividend from $ticker';
    }

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

    await repository.upsertHolding(Holding(
        id: existingHolding?.id ?? '',
        userId: transaction.userId,
        stockId: transaction.stockId,
        avgPrice: newTotalPrice / newQuantity,
        quantity: newQuantity,
        profit: profit,
        dividend: dividend));
  }
}
