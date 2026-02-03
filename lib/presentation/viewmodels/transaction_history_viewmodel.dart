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

  String _typeFilter = 'All';
  String get typeFilter => _typeFilter;

  String? _tickerFilter;
  String? get tickerFilter => _tickerFilter;

  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  void setTypeFilter(String filter) {
    _typeFilter = filter;
    notifyListeners();
  }

  void setTickerFilter(String? ticker) {
    _tickerFilter = ticker;
    notifyListeners();
  }

  void setDateFilter(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  List<String> get availableTickers {
    return _transactions.map((t) => t.ticker).toSet().toList()..sort();
  }

  List<Transaction> get filteredTransactions {
    return _transactions.where((t) {
      final matchesType = _typeFilter == 'All' || t.typeString == _typeFilter;
      final matchesTicker = _tickerFilter == null || t.ticker == _tickerFilter;

      bool matchesDate = true;
      if (_startDate != null) {
        matchesDate = matchesDate &&
            (t.date.isAfter(_startDate!) ||
                t.date.isAtSameMomentAs(_startDate!));
      }
      if (_endDate != null) {
        // End date should be inclusive till end of day
        final inclusiveEnd = DateTime(
            _endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
        matchesDate = matchesDate && t.date.isBefore(inclusiveEnd);
      }

      return matchesType && matchesTicker && matchesDate;
    }).toList();
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
