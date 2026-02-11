import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import '../../core/di/service_locator.dart';
import '../../domain/entities/cash_transaction.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../domain/usecases/wallet_usecases.dart';
import 'package:uuid/uuid.dart';

class CashViewModel extends ChangeNotifier {
  final PortfolioRepository repository;
  final String userId;

  CashViewModel({required this.repository, required this.userId}) {
    fetchCashData();
  }

  List<CashTransaction> _transactions = [];
  List<CashTransaction> get transactions => _transactions;

  double _balance = 0.0;
  double get balance => _balance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCashData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getCashTransactions(),
        repository.getCashBalance(),
      ]);
      _transactions = results[0] as List<CashTransaction>;
      _balance = results[1] as double;
    } catch (e) {
      debugPrint('Error fetching cash data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> addTransaction({
    required double? amount,
    required String type,
    String? description,
  }) async {
    if (_isLoading) {
      return 'Please wait for the previous transaction to complete';
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (amount == null || amount <= 0) {
        return 'Amount must be positive';
      }
      const allowedTypes = {'DEPOSIT', 'WITHDRAWAL'};
      if (!allowedTypes.contains(type)) {
        return 'Unsupported transaction type: $type';
      }

      if (type == 'WITHDRAWAL' && amount > balance) {
        return 'Insufficient balance';
      }

      final normalizedAmount = amount.abs();

      final transaction = CashTransaction(
        id: const Uuid().v4(),
        userId: userId,
        amount: type == 'DEPOSIT' ? normalizedAmount : -normalizedAmount,
        type: type,
        description: description,
        createdAt: DateTime.now(),
      );

      await repository.addCashTransaction(transaction);

      // Update wallet balance based on transaction type
      await _updateWalletBalance(type, normalizedAmount);

      await fetchCashData();
    } catch (e) {
      return AppErrorHandler.mapErrorToString(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> _updateWalletBalance(String type, double amount) async {
    try {
      final getWallet = getIt<GetWallet>();
      final createWallet = getIt<CreateWallet>();
      final addToWallet = getIt<AddToWalletBalance>();

      // Check if wallet exists
      Wallet? wallet = await getWallet.call(userId);

      // If wallet doesn't exist, create it first
      if (wallet == null) {
        wallet = await createWallet.call(userId, initialBalance: 0);
        debugPrint('Created new wallet for user: $userId');
      }

      // Calculate amount to add/subtract
      double amountToUpdate = 0;
      if (type == 'DEPOSIT') {
        // Add to wallet for deposits
        amountToUpdate = amount;
      } else if (type == 'WITHDRAWAL') {
        // Deduct from wallet for withdrawals
        amountToUpdate = -amount;
      }

      // Update wallet balance
      if (amountToUpdate != 0) {
        await addToWallet.call(userId, amountToUpdate);
        debugPrint('Updated wallet balance by: $amountToUpdate');
      }
    } catch (e) {
      debugPrint('Error updating wallet balance for cash transaction: $e');
      rethrow;
    }
  }
}
