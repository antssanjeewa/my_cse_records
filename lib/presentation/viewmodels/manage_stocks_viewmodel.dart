import 'package:flutter/material.dart';
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

  Future<void> addStock({
    required String ticker,
    required String name,
    String? sector,
    required double lastPrice,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.addStock(
        ticker: ticker,
        name: name,
        sector: sector,
        lastPrice: lastPrice,
      );

      // Refresh the list after adding
      await fetchStocks();
    } catch (e) {
      debugPrint('Error adding stock: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateStock({
    required int stockId,
    String? sector,
    required double lastPrice,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.updateStock(
        stockId: stockId,
        sector: sector,
        lastPrice: lastPrice,
      );

      // Refresh the list after updating
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
      // Delete from database first
      await repository.deleteStock(stockId);

      // Update local state after successful deletion
      _stocks.removeWhere((stock) => stock.id == stockId);
      _applyFilters();

      // Optional: Refresh from database to ensure consistency
      // Comment out if you trust the local state after deletion
      await fetchStocks();
    } catch (e) {
      debugPrint('Error deleting stock: $e');
      // Refresh to restore correct state if deletion failed
      await fetchStocks();
      rethrow;
    }
  }
}
