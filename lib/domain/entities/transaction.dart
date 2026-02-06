import 'stock.dart';

enum TransactionType { buy, sell }

class Transaction {
  final String id;
  final String userId;
  final int stockId;
  final TransactionType type;
  final double qty;
  final double unit_price;
  final double total_price;
  final DateTime date;
  final Stock? stock;

  Transaction({
    required this.id,
    required this.userId,
    required this.stockId,
    required this.type,
    required this.qty,
    required this.unit_price,
    required this.total_price,
    required this.date,
    this.stock,
  });

  // Proxy getters for UI compatibility
  String get ticker => stock?.ticker ?? 'N/A';
  String get name => stock?.name ?? 'Unknown';
  double get quantity => qty;
  String get typeString => type == TransactionType.buy ? 'Buy' : 'Sell';
}
