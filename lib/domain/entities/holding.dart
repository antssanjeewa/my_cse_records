import 'stock.dart';

class Holding {
  final String id;
  final String userId;
  final int stockId;
  final double avgPrice;
  final double quantity;
  final double profit;
  final double dividend;
  final Stock? stock;

  Holding({
    required this.id,
    required this.userId,
    required this.stockId,
    required this.avgPrice,
    required this.quantity,
    this.profit = 0,
    this.dividend = 0,
    this.stock,
  });

  String get ticker => stock?.ticker ?? 'N/A';
  String get name => stock?.name ?? 'Unknown';
  String get sector => stock?.sector ?? 'General';
  String get startYear => stock?.startYear ?? 'N/A';
  double get totalPrice => avgPrice * quantity;
  double get profitPercent => totalPrice == 0 ? 0 : (profit / totalPrice) * 100;
}
