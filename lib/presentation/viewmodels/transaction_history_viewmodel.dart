import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_transactions.dart';

class TransactionHistoryViewModel extends ChangeNotifier {
  final GetTransactions getTransactions;

  TransactionHistoryViewModel({required this.getTransactions}) {
    fetchTransactions();
  }

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _filter = 'All';
  String get filter => _filter;

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  List<Transaction> get filteredTransactions {
    if (_filter == 'All') return _transactions;
    return _transactions.where((t) => t.typeString == _filter).toList();
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await getTransactions();
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }
}
