class CashTransaction {
  final String id;
  final String userId;
  final double amount;
  final String type; // 'DEPOSIT' | 'WITHDRAWAL' | 'BUY' | 'SELL' | 'DIVIDEND'
  final String? description;
  final DateTime createdAt;

  CashTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.description,
    required this.createdAt,
  });

  bool get isCredit => amount > 0;
}
