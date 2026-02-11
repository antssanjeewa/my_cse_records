import 'package:flutter/material.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../../domain/entities/holding.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/usecases/get_portfolio_summary.dart';
import '../../domain/usecases/wallet_usecases.dart';
import '../../core/di/service_locator.dart';

class HomeViewModel extends ChangeNotifier {
  final GetPortfolioSummary getPortfolioSummary;

  HomeViewModel({required this.getPortfolioSummary}) {
    fetchSummary();
  }

  PortfolioSummary? _summary;
  PortfolioSummary? get summary => _summary;

  Wallet? _wallet;
  Wallet? get wallet => _wallet;

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

      // Fetch wallet data
      final userId =
          getIt<GetWallet>().repository.runtimeType; // Placeholder to get user
      // We'll fetch wallet after getting current user context
      await _fetchWallet();
    } catch (e) {
      debugPrint('Error fetching summary: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchWallet() async {
    try {
      // This should be called after we have user context
      // For now, it's a placeholder that will be called from context
    } catch (e) {
      debugPrint('Error fetching wallet: $e');
    }
  }

  Future<void> fetchWalletForUser(String userId) async {
    try {
      final getWallet = getIt<GetWallet>();
      _wallet = await getWallet.call(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching wallet for user: $e');
    }
  }
}
