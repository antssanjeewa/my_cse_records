import '../../domain/entities/stock.dart';

class StockModel extends Stock {
  StockModel({
    required super.id,
    required super.ticker,
    required super.name,
    super.sector,
    required super.lastPrice,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'],
      ticker: json['ticker'],
      name: json['name'],
      sector: json['sector'],
      lastPrice: (json['last_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticker': ticker,
      'name': name,
      'sector': sector,
      'last_price': lastPrice,
    };
  }
}
