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
    try {
      // In a real app, you'd call an API endpoint to add the stock
      // For now, we'll just add it locally and refresh
      debugPrint('Adding stock: $ticker - $name');

      // Refresh the list after adding
      await fetchStocks();
    } catch (e) {
      debugPrint('Error adding stock: $e');
    }
  }

  Future<void> updateStock({
    required int stockId,
    String? sector,
    required double lastPrice,
  }) async {
    try {
      // In a real app, you'd call an API endpoint to update the stock
      debugPrint('Updating stock ID: $stockId with price: $lastPrice');

      // Refresh the list after updating
      await fetchStocks();
    } catch (e) {
      debugPrint('Error updating stock: $e');
    }
  }

  Future<void> deleteStock(int stockId) async {
    try {
      // In a real app, you'd call an API endpoint to delete the stock
      debugPrint('Deleting stock ID: $stockId');

      // Optimistically remove from local list
      _stocks.removeWhere((stock) => stock.id == stockId);
      _applyFilters();

      // Refresh the list after deleting
      await fetchStocks();
    } catch (e) {
      debugPrint('Error deleting stock: $e');
      // Refresh to restore the list if deletion failed
      await fetchStocks();
    }
  }
}
