import 'package:flutter/material.dart';
import '../../domain/entities/holding.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_transactions.dart';

enum TransactionFilter { all, buy, sell, dividend }

class HoldingDetailsViewModel extends ChangeNotifier {
  final GetTransactions getTransactions;
  final Holding holding;
  final double totalPortfolioValue;

  HoldingDetailsViewModel({
    required this.getTransactions,
    required this.holding,
    double? totalPortfolioValue,
  }) : totalPortfolioValue = totalPortfolioValue ?? 0 {
    fetchTransactions();
  }

  List<Transaction> _allTransactions = [];
  TransactionFilter _currentFilter = TransactionFilter.all;

  TransactionFilter get currentFilter => _currentFilter;

  List<Transaction> get transactions {
    if (_currentFilter == TransactionFilter.all) return _allTransactions;
    return _allTransactions.where((t) {
      if (_currentFilter == TransactionFilter.buy) {
        return t.type == TransactionType.buy;
      }
      if (_currentFilter == TransactionFilter.sell) {
        return t.type == TransactionType.sell;
      }
      if (_currentFilter == TransactionFilter.dividend) {
        return t.type == TransactionType.dividend;
      }
      return true;
    }).toList();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double get marketValue => holding.totalPrice + holding.profit;
  double get concentration => totalPortfolioValue == 0
      ? 0.0
      : (marketValue / totalPortfolioValue) * 100;

  void setFilter(TransactionFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allTransactions = await getTransactions(
        stockId: holding.stockId,
        limit: 100,
      );
    } catch (e) {
      debugPrint('Error fetching transactions for holding: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
