import 'stock.dart';

enum TransactionType { buy, sell, dividend }

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.buy:
        return 'BUY';
      case TransactionType.sell:
        return 'SELL';
      case TransactionType.dividend:
        return 'DIVIDEND';
    }
  }

  TransactionType get typeEnum {
    {
      switch (name) {
        case 'BUY':
          return TransactionType.buy;
        case 'SELL':
          return TransactionType.sell;
        case 'DIVIDEND':
          return TransactionType.dividend;
        default:
          throw Exception('Invalid transaction type name');
      }
    }
  }
}

class Transaction {
  final String id;
  final String userId;
  final int stockId;
  final TransactionType type;
  final double qty;
  final double unitPrice;
  final double totalPrice;
  final DateTime date;
  final Stock? stock;

  Transaction({
    required this.id,
    required this.userId,
    required this.stockId,
    required this.type,
    required this.qty,
    required this.unitPrice,
    required this.totalPrice,
    required this.date,
    this.stock,
  });

  // Proxy getters for UI compatibility
  String get ticker => stock?.ticker ?? 'N/A';
  String get name => stock?.name ?? 'Unknown';
  double get quantity => qty;
  String get typeString => type.name.toUpperCase();
}
