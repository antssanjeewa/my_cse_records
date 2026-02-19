import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import '../../domain/entities/stock.dart';
import '../../domain/repositories/portfolio_repository.dart';

class ManageStocksViewModel extends ChangeNotifier {
  final PortfolioRepository repository;

  ManageStocksViewModel({required this.repository}) {
    fetchStocks();
  }

  List<Stock> _stocks = [];
  List<Stock> get stocks => _stocks;

  List<Stock> _filteredStocks = [];
  List<Stock> get filteredStocks => _filteredStocks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';

  Future<void> fetchStocks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stocks = await repository.getStocks();
      _applyFilters();
    } catch (e) {
      debugPrint('Error fetching stocks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    if (_searchQuery.isEmpty) {
      _filteredStocks = List.from(_stocks);
    } else {
      _filteredStocks = _stocks.where((stock) {
        return stock.ticker.toLowerCase().contains(_searchQuery) ||
            stock.name.toLowerCase().contains(_searchQuery) ||
            (stock.sector?.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }
    notifyListeners();
  }

  Future<String?> addStock({
    required String ticker,
    required String name,
    String? sector,
    required double? lastPrice,
  }) async {
    if (ticker.isEmpty || name.isEmpty || lastPrice == null || lastPrice <= 0) {
      return 'Please fill in all required fields with valid values';
    }

    _isLoading = true;
    notifyListeners();

    try {
      await repository.addStock(
        ticker: ticker,
        name: name,
        sector: sector,
        lastPrice: lastPrice,
      );

      await fetchStocks();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AppErrorHandler.mapErrorToString(e);
    }
    return null;
  }

  Future<void> updateStock({
    required int stockId,
    String? name,
    String? sector,
    required double lastPrice,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.updateStock(
        stockId: stockId,
        name: name,
        sector: sector,
        lastPrice: lastPrice,
      );

      await fetchStocks();
    } catch (e) {
      debugPrint('Error updating stock: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteStock(int stockId) async {
    try {
      await repository.deleteStock(stockId);

      _stocks.removeWhere((stock) => stock.id == stockId);
      _applyFilters();

      await fetchStocks();
    } catch (e) {
      debugPrint('Error deleting stock: $e');
      await fetchStocks();
      rethrow;
    }
  }
}
