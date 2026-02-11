import 'package:flutter/material.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../../domain/entities/holding.dart';
import '../../domain/usecases/get_portfolio_summary.dart';

class HomeViewModel extends ChangeNotifier {
  final GetPortfolioSummary getPortfolioSummary;

  HomeViewModel({required this.getPortfolioSummary}) {
    fetchSummary();
  }

  PortfolioSummary? _summary;
  PortfolioSummary? get summary => _summary;

  // Also need holdings for Top 5 list
  final List<Holding> _topHoldings = [];
  List<Holding> get topHoldings => _topHoldings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchSummary() async {
    _isLoading = true;
    notifyListeners();

    try {
      _summary = await getPortfolioSummary();

      await _fetchWallet();
    } catch (e) {
      debugPrint('Error fetching summary: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchWallet() async {
    // Handled in GetPortfolioSummary
  }
}
