import '../../domain/entities/cash_transaction.dart';

class CashTransactionModel extends CashTransaction {
  CashTransactionModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.type,
    super.description,
    required super.createdAt,
  });

  factory CashTransactionModel.fromJson(Map<String, dynamic> json) {
    return CashTransactionModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? 'DEPOSIT',
      description: json['description']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'type': type,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
