import 'package:flutter/material.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../core/services/backup_service.dart';
import '../../data/models/holding_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/cash_transaction_model.dart';

class SettingsViewModel extends ChangeNotifier {
  final PortfolioRepository repository;
  final String userId;

  SettingsViewModel({required this.repository, required this.userId});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _statusMessage;
  String? get statusMessage => _statusMessage;

  Future<void> runBackup() async {
    _isLoading = true;
    _statusMessage = 'Preparing backup...';
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getHoldings(),
        repository.getTransactions(limit: 100),
        repository.getCashTransactions(),
      ]);

      final holdings = results[0] as List;
      final transactions = results[1] as List;
      final cashTransactions = results[2] as List;

      await BackupService.createBackup(
        holdings: holdings.cast(),
        transactions: transactions.cast(),
        cashTransactions: cashTransactions.cast(),
      );

      _statusMessage = 'Backup successful';
    } catch (e) {
      _statusMessage = 'Backup failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> runRestore() async {
    final backupData = await BackupService.loadBackup();
    if (backupData == null) return;

    _isLoading = true;
    _statusMessage = 'Restoring data...';
    notifyListeners();

    try {
      // 1. Restore Holdings
      if (backupData['holdings'] != null) {
        final holdingsJson = backupData['holdings'] as List;
        for (var hJson in holdingsJson) {
          final model = HoldingModel.fromJson(hJson);
          await repository.upsertHolding(model);
        }
      }

      // 2. Restore Transactions
      if (backupData['transactions'] != null) {
        final txsJson = backupData['transactions'] as List;
        for (var tJson in txsJson) {
          final model = TransactionModel.fromJson(tJson);
          await repository.addTransaction(model);
        }
      }

      // 3. Restore Cash Transactions
      if (backupData['cashTransactions'] != null) {
        final cashJson = backupData['cashTransactions'] as List;
        for (var cJson in cashJson) {
          final model = CashTransactionModel.fromJson(cJson);
          await repository.addCashTransaction(model);
        }
      }

      _statusMessage = 'Restore successful';
    } catch (e) {
      _statusMessage = 'Restore failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
