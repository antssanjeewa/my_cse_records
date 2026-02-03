import '../entities/holding.dart';
import '../entities/transaction.dart';
import '../repositories/portfolio_repository.dart';

class AddTransaction {
  final PortfolioRepository repository;

  AddTransaction(this.repository);

  Future<void> call(Transaction transaction) async {
    await repository.addTransaction(transaction);

    final existingHolding = await repository.getHoldingByStock(
      transaction.userId,
      transaction.stockId,
    );

    double newQuantity = transaction.qty;
    double newAvgPrice = transaction.price;

    if (existingHolding != null) {
      if (transaction.type == TransactionType.buy) {
        newQuantity = existingHolding.quantity + transaction.qty;
        newAvgPrice = ((existingHolding.quantity * existingHolding.avgPrice) +
                (transaction.qty * transaction.price)) /
            newQuantity;
      } else {
        // Assuming TransactionType.sell
        if (existingHolding.quantity < transaction.qty) {
          throw Exception('Insufficient holdings to sell');
        }
        newQuantity = existingHolding.quantity - transaction.qty;
        newAvgPrice = existingHolding.avgPrice; // Cost basis remains the same
      }
    } else {
      if (transaction.type == TransactionType.sell) {
        throw Exception('Cannot sell stock with no existing holdings');
      }
    }

    await repository.upsertHolding(Holding(
      id: existingHolding?.id ?? '',
      userId: transaction.userId,
      stockId: transaction.stockId,
      avgPrice: newAvgPrice,
      quantity: newQuantity,
    ));
  }
}
