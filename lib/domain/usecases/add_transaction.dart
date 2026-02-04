import '../entities/holding.dart';
import '../entities/transaction.dart';
import '../repositories/portfolio_repository.dart';

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
    double newAvgPrice = transaction.price;
    double newTotalPrice = transaction.totalPrice;

    if (transaction.type == TransactionType.buy &&
        balance < transaction.totalPrice) {
      throw Exception('Insufficient balance');
    }

    if (existingHolding != null) {
      if (transaction.type == TransactionType.buy) {
        newQuantity = existingHolding.quantity + transaction.qty;
        newAvgPrice = ((existingHolding.quantity * existingHolding.avgPrice) +
                (transaction.qty * transaction.price)) /
            newQuantity;
        newTotalPrice = existingHolding.totalPrice + transaction.totalPrice;
      } else {
        // Assuming TransactionType.sell
        if (existingHolding.quantity < transaction.qty) {
          throw Exception('Insufficient holdings to sell');
        }
        newQuantity = existingHolding.quantity - transaction.qty;
        newAvgPrice = existingHolding.avgPrice;
        newTotalPrice = existingHolding.totalPrice - transaction.totalPrice;
      }
    } else {
      if (transaction.type == TransactionType.sell) {
        throw Exception('Cannot sell stock with no existing holdings');
      }
    }

    await repository.addTransaction(transaction);

    await repository.upsertHolding(Holding(
      id: existingHolding?.id ?? '',
      userId: transaction.userId,
      stockId: transaction.stockId,
      avgPrice: newAvgPrice,
      quantity: newQuantity,
      totalPrice: newTotalPrice,
    ));
  }
}
