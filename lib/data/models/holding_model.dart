import '../../domain/entities/holding.dart';
import 'stock_model.dart';

class HoldingModel extends Holding {
  HoldingModel({
    required super.id,
    required super.userId,
    required super.stockId,
    required super.avgPrice,
    required super.quantity,
    super.profit = 0,
    super.dividend = 0,
    super.stock,
  });

  factory HoldingModel.fromJson(Map<String, dynamic> json) {
    return HoldingModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      stockId: json['stock_id'] as int,
      avgPrice: (json['avg_price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
      dividend: (json['dividend'] as num?)?.toDouble() ?? 0.0,
      stock:
          json['stocks'] != null ? StockModel.fromJson(json['stocks']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'stock_id': stockId,
      'avg_price': avgPrice,
      'quantity': quantity,
      'profit': profit,
      'dividend': dividend,
    };
  }
}
