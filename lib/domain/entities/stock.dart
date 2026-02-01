class Stock {
  final int id;
  final String ticker;
  final String name;
  final String? sector;
  final double lastPrice;

  Stock({
    required this.id,
    required this.ticker,
    required this.name,
    this.sector,
    required this.lastPrice,
  });
}
