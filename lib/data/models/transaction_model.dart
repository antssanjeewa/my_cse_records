import '../../domain/entities/transaction.dart';
import 'stock_model.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.userId,
    required super.stockId,
    required super.type,
    required super.qty,
    required super.price,
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
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
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
      'price': price,
      'date': date.toIso8601String(),
    };
  }
}
