class Transaction {
  final String id;
  final String ticker;
  final String name;
  final String type; // 'Buy' or 'Sell'
  final DateTime date;
  final double quantity;
  final double price;

  Transaction({
    required this.id,
    required this.ticker,
    required this.name,
    required this.type,
    required this.date,
    required this.quantity,
    required this.price,
  });

  double get totalValue => quantity * price;
}
