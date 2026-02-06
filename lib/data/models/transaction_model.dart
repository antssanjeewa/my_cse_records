import '../../domain/entities/transaction.dart';
import 'stock_model.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.userId,
    required super.stockId,
    required super.type,
    required super.qty,
    required super.unit_price,
    required super.total_price,
    required super.date,
    super.stock,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      stockId: json['stock_id'] as int? ?? 0,
      type: json['type'] == 'BUY' ? TransactionType.buy : TransactionType.sell,
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
      unit_price: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      total_price: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.fromMillisecondsSinceEpoch(0),
      stock:
          json['stocks'] != null ? StockModel.fromJson(json['stocks']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'stock_id': stockId,
      'type': type == TransactionType.buy ? 'BUY' : 'SELL',
      'qty': qty,
      'unit_price': unit_price,
      'total_price': total_price,
      'date': date.toIso8601String(),
    };
  }
}
