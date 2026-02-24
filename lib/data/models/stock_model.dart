import '../../core/utils/formatters.dart';
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
      id: json['id'] as int? ?? 0,
      ticker: json['ticker']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sector: json['sector']?.toString(),
      lastPrice: AppFormatters.roundTo(
          (json['last_price'] as num?)?.toDouble() ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticker': ticker,
      'name': name,
      'sector': sector,
      'last_price': AppFormatters.roundTo(lastPrice),
    };
  }
}
