import 'package:flutter/material.dart';
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

  Future<void> addTransaction({
    required double amount,
    required String type,
    String? description,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (amount <= 0) {
        debugPrint('Amount must be positive');
        return;
      }
      const allowedTypes = {'DEPOSIT', 'WITHDRAWAL'};
      if (!allowedTypes.contains(type)) {
        debugPrint('Unsupported transaction type: $type');
        return;
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
      debugPrint('Error adding cash transaction: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
