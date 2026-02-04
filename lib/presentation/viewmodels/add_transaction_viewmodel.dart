import 'package:flutter/material.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/get_stocks.dart';
import 'package:uuid/uuid.dart';

class AddTransactionViewModel extends ChangeNotifier {
  final GetStocks getStocks;
  final AddTransaction addTransaction;
  final String userId;

  AddTransactionViewModel({
    required this.getStocks,
    required this.addTransaction,
    required this.userId,
  }) {
    fetchStocks();
  }

  List<Stock> _stocks = [];
  List<Stock> get stocks => _stocks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Stock? _selectedStock;
  Stock? get selectedStock => _selectedStock;

  TransactionType _type = TransactionType.buy;
  TransactionType get type => _type;

  double _quantity = 0;
  double get quantity => _quantity;

  double _unitPrice = 0;
  double get unitPrice => _unitPrice;

  DateTime _date = DateTime.now();
  DateTime get date => _date;

  static const double feePercentage = 0.0114; // 1.14%

  double get totalPrice {
    final subtotal = _quantity * _unitPrice;
    if (_type == TransactionType.buy) {
      return subtotal * (1 + feePercentage);
    } else {
      return subtotal * (1 - feePercentage);
    }
  }

  void selectStock(Stock? stock) {
    _selectedStock = stock;
    if (stock != null && _unitPrice == 0) {
      _unitPrice = stock.lastPrice;
    }
    notifyListeners();
  }

  void setType(TransactionType type) {
    _type = type;
    notifyListeners();
  }

  void setQuantity(double qty) {
    _quantity = qty;
    notifyListeners();
  }

  void setUnitPrice(double price) {
    _unitPrice = price;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  Future<void> fetchStocks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stocks = await getStocks();
    } catch (e) {
      debugPrint('Error fetching stocks: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveTransaction() async {
    _errorMessage = null;

    if (_selectedStock == null) {
      _errorMessage = 'Please select a company';
      notifyListeners();
      return false;
    }

    if (_quantity <= 0) {
      _errorMessage = 'Quantity must be greater than 0';
      notifyListeners();
      return false;
    }

    if (_unitPrice <= 0) {
      _errorMessage = 'Unit price must be greater than 0';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final transaction = Transaction(
        id: const Uuid().v4(),
        userId: userId,
        stockId: _selectedStock!.id,
        type: _type,
        qty: _quantity,
        price: _unitPrice,
        totalPrice: totalPrice,
        date: _date,
      );

      await addTransaction(transaction);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving transaction: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
