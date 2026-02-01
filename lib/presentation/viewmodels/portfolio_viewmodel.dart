import 'package:flutter/material.dart';
import '../../domain/entities/holding.dart';
import '../../domain/usecases/get_holdings.dart';

class PortfolioViewModel extends ChangeNotifier {
  final GetHoldings getHoldings;

  PortfolioViewModel({required this.getHoldings}) {
    fetchHoldings();
  }

  List<Holding> _holdings = [];
  List<Holding> get holdings => _holdings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchHoldings() async {
    _isLoading = true;
    notifyListeners();

    _holdings = await getHoldings();

    _isLoading = false;
    notifyListeners();
  }
}
