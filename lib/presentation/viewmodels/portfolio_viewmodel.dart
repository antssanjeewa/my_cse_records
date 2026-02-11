import 'package:flutter/material.dart';
import '../../domain/entities/holding.dart';
import '../../domain/usecases/get_portfolio_summary.dart';

class PortfolioViewModel extends ChangeNotifier {
  final GetPortfolioSummary getPortfolioSummary;

  PortfolioViewModel({required this.getPortfolioSummary}) {
    fetchHoldings();
  }

  List<Holding> _holdings = [];
  List<Holding> get holdings => _holdings;

  double _cashBalance = 0;
  double get cashBalance => _cashBalance;

  double get totalValue => _holdings.fold(0, (sum, h) => sum + h.totalPrice);

  double get totalMarketValue =>
      _holdings.fold(0, (sum, h) => sum + h.totalPrice + h.profit);

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _sortBy = 'Name';
  String get sortBy => _sortBy;

  String _sectorFilter = 'All';
  String get sectorFilter => _sectorFilter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> get availableSectors {
    final sectors = _holdings.map((h) => h.sector).toSet().toList();
    sectors.sort();
    return ['All', ...sectors];
  }

  List<Holding> get filteredHoldings {
    List<Holding> list = _holdings.where((h) {
      final matchesSearch =
          h.ticker.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              h.name.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesSector = _sectorFilter == 'All' || h.sector == _sectorFilter;

      return matchesSearch && matchesSector;
    }).toList();

    // Sorting
    if (_sortBy == 'Name') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'Price') {
      list.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
    } else if (_sortBy == 'Quantity') {
      list.sort((a, b) => b.quantity.compareTo(a.quantity));
    } else if (_sortBy == 'Profit %') {
      list.sort((a, b) => b.profitPercent.compareTo(a.profitPercent));
    }

    return list;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String criteria) {
    _sortBy = criteria;
    notifyListeners();
  }

  void setSectorFilter(String sector) {
    _sectorFilter = sector;
    notifyListeners();
  }

  Future<void> fetchHoldings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final summary = await getPortfolioSummary();
      _holdings = summary.holdings;
      _cashBalance = summary.cashBalance;
    } catch (e) {
      debugPrint('Error fetching portfolio summary: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
