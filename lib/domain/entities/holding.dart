import 'stock.dart';

class Holding {
  final String id;
  final String userId;
  final int stockId;
  final double avgPrice;
  final double quantity;
  final Stock? stock;

  Holding({
    required this.id,
    required this.userId,
    required this.stockId,
    required this.avgPrice,
    required this.quantity,
    this.stock,
  });

  // Proxy getters for ease of use in UI
  String get ticker => stock?.ticker ?? 'N/A';
  String get name => stock?.name ?? 'Unknown';
  String get sector => stock?.sector ?? 'General';
  double get marketPrice => stock?.lastPrice ?? 0;

  double get value => quantity * marketPrice;
  double get profit => value - (quantity * avgPrice);
  double get profitPercent =>
      avgPrice > 0 ? ((marketPrice - avgPrice) / avgPrice) * 100 : 0;
}
