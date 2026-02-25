import 'package:flutter/material.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_stocks.dart';
import '../../domain/usecases/get_transactions.dart';

class TransactionHistoryViewModel extends ChangeNotifier {
  final GetTransactions getTransactions;
  final GetStocks getStocks;

  TransactionHistoryViewModel({
    required this.getTransactions,
    required this.getStocks,
  }) {
    fetchTransactions();
    fetchStocks();
  }

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  List<Stock> _stocks = [];
  List<Stock> get stocks => _stocks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _typeFilter = 'All';
  String get typeFilter => _typeFilter;

  // Track the actual Stock ID for server-side filtering
  int? _stockIdFilter;
  String? _tickerFilter;
  String? get tickerFilter => _tickerFilter;

  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  int _limit = 10;
  int get limit => _limit;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  void setTypeFilter(String filter) {
    if (_typeFilter == filter) return;
    _typeFilter = filter;
    fetchTransactions();
  }

  void setStockFilter(int? stockId, String? ticker) {
    if (_stockIdFilter == stockId) return;
    _stockIdFilter = stockId;
    _tickerFilter = ticker;
    fetchTransactions();
  }

  void setDateFilter(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    fetchTransactions();
  }

  void loadMore() {
    _limit += 10;
    fetchTransactions();
  }

  List<Stock> get uniqueStocks {
    final list = List<Stock>.from(_stocks);
    list.sort((a, b) => a.ticker.compareTo(b.ticker));
    return list;
  }

  List<Transaction> get filteredTransactions => _transactions;

  Future<void> fetchStocks() async {
    try {
      _stocks = await getStocks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching stocks: $e');
    }
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await getTransactions(
        stockId: _stockIdFilter,
        type: _typeFilter == 'All' ? null : _typeFilter,
        startDate: _startDate,
        endDate: _endDate,
        limit: _limit,
      );

      _hasMore = results.length >= _limit;
      _transactions = results;
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Transaction>> getTransactionsForMonth(int month, int year) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    return await getTransactions(
      startDate: startDate,
      endDate: endDate,
      limit: 100,
    );
  }
}
