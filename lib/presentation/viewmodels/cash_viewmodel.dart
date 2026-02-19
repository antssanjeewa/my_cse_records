import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import '../../domain/entities/cash_transaction.dart';
import '../../domain/repositories/portfolio_repository.dart';
import 'package:uuid/uuid.dart';

class CashViewModel extends ChangeNotifier {
  final PortfolioRepository repository;
  final String userId;

  CashViewModel({required this.repository, required this.userId}) {
    fetchCashData();
  }

  List<CashTransaction> _transactions = [];
  List<CashTransaction> get transactions => _transactions;

  double _balance = 0.0;
  double get balance => _balance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double get totalCash => _transactions
      .where((t) => t.type == 'DEPOSIT' || t.type == 'WITHDRAWAL')
      .fold(0.0, (sum, t) => sum + t.amount);

  Future<void> fetchCashData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getCashTransactions(),
        repository.getCashBalance(),
      ]);
      _transactions = results[0] as List<CashTransaction>;
      _balance = results[1] as double;
    } catch (e) {
      debugPrint('Error fetching cash data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> addTransaction({
    required double? amount,
    required String type,
    String? description,
  }) async {
    if (_isLoading) {
      return 'Please wait for the previous transaction to complete';
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (amount == null || amount <= 0) {
        return 'Amount must be positive';
      }
      const allowedTypes = {'DEPOSIT', 'WITHDRAWAL'};
      if (!allowedTypes.contains(type)) {
        return 'Unsupported transaction type: $type';
      }

      if (type == 'WITHDRAWAL' && amount > balance) {
        return 'Insufficient balance';
      }

      final normalizedAmount = amount.abs();

      final transaction = CashTransaction(
        id: const Uuid().v4(),
        userId: userId,
        amount: type == 'DEPOSIT' ? normalizedAmount : -normalizedAmount,
        type: type,
        description: description,
        createdAt: DateTime.now(),
      );

      await repository.addCashTransaction(transaction);

      await fetchCashData();
    } catch (e) {
      return AppErrorHandler.mapErrorToString(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }
}
