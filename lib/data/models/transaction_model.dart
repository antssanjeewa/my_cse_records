import '../../core/utils/formatters.dart';
import '../../domain/entities/transaction.dart';
import 'stock_model.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.userId,
    required super.stockId,
    required super.type,
    required super.qty,
    required super.unitPrice,
    required super.totalPrice,
    required super.date,
    super.stock,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      stockId: json['stock_id'] as int? ?? 0,
      type: (TransactionType.values.firstWhere(
        (e) => e.name.toUpperCase() == (json['type'] as String).toUpperCase(),
        orElse: () => throw Exception('Invalid transaction type'),
      )),
      qty: AppFormatters.roundTo((json['qty'] as num?)?.toDouble() ?? 0.0),
      unitPrice: AppFormatters.roundTo(
          (json['unit_price'] as num?)?.toDouble() ?? 0.0),
      totalPrice: AppFormatters.roundTo(
          (json['total_price'] as num?)?.toDouble() ?? 0.0),
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.fromMillisecondsSinceEpoch(0),
      stock:
          json['stocks'] != null ? StockModel.fromJson(json['stocks']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'stock_id': stockId,
      'type': type.name.toUpperCase(),
      'qty': AppFormatters.roundTo(qty),
      'unit_price': AppFormatters.roundTo(unitPrice),
      'total_price': AppFormatters.roundTo(totalPrice),
      'date': date.toIso8601String(),
    };
  }
}
