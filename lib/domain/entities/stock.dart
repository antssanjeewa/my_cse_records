class Stock {
  final int id;
  final String ticker;
  final String name;
  final String? sector;
  final double lastPrice;
  final String? startYear;

  Stock({
    required this.id,
    required this.ticker,
    required this.name,
    this.sector,
    this.startYear,
    required this.lastPrice,
  });
}
