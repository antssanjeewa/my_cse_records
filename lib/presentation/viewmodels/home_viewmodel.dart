import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../../domain/entities/holding.dart';
import '../../domain/usecases/get_portfolio_summary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_transactions.dart';

class HomeViewModel extends ChangeNotifier {
  final GetPortfolioSummary getPortfolioSummary;
  final GetTransactions getTransactions;

  HomeViewModel({
    required this.getPortfolioSummary,
    required this.getTransactions,
  }) {
    fetchSummary();
  }

  PortfolioSummary? _summary;
  PortfolioSummary? get summary => _summary;

  final List<Holding> _topHoldings = [];
  List<Holding> get topHoldings => _topHoldings;

  List<Transaction> _recentTransactions = [];
  List<Transaction> get recentTransactions => _recentTransactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isMarketOpen = false;
  bool get isMarketOpen => _isMarketOpen;

  String _currentTime = '';
  String get currentTime => _currentTime;
  Timer? _timer;
  Timer? _delayTimer;

  Future<void> fetchSummary() async {
    _isLoading = true;
    _updateTimeAndStatus();
    _startClock();
    notifyListeners();

    try {
      final results = await Future.wait([
        getPortfolioSummary(),
        getTransactions(limit: 20), // Fetch more for activity chart
      ]);

      _summary = results[0] as PortfolioSummary;
      _recentTransactions = results[1] as List<Transaction>;

      // Update top holdings from summary
      if (_summary != null) {
        _topHoldings.clear();
        final sorted = List<Holding>.from(_summary!.holdings)
          ..sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
        _topHoldings.addAll(sorted.take(5));
      }
    } catch (e) {
      debugPrint('Error fetching summary or transactions: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _startClock() {
    final now = DateTime.now();
    final secondsUntilNextMinute = 60 - now.second;

    _delayTimer = Timer(Duration(seconds: secondsUntilNextMinute), () {
      _updateTimeAndStatus();
      notifyListeners();

      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        _updateTimeAndStatus();
        notifyListeners();
      });
    });
  }

  void _updateTimeAndStatus() {
    final now = DateTime.now();

    _currentTime =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    const startMinutes = 9 * 60 + 30;
    const endMinutes = 14 * 60 + 30;
    final currentMinutes = now.hour * 60 + now.minute;

    final isWeekday = now.weekday >= 1 && now.weekday <= 5;

    _isMarketOpen = isWeekday &&
        currentMinutes >= startMinutes &&
        currentMinutes < endMinutes;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _delayTimer?.cancel();
    super.dispose();
  }
}
