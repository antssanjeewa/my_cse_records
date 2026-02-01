class Holding {
  final String ticker;
  final String name;
  final String sector;
  final double quantity;
  final double avgCost;
  final double marketPrice;

  Holding({
    required this.ticker,
    required this.name,
    required this.sector,
    required this.quantity,
    required this.avgCost,
    required this.marketPrice,
  });

  double get value => quantity * marketPrice;
  double get profit => value - (quantity * avgCost);
  double get profitPercent => ((marketPrice - avgCost) / avgCost) * 100;
}
