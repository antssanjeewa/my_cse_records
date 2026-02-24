import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/holding.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/cash_transaction.dart';
import '../../data/models/holding_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/cash_transaction_model.dart';

class BackupService {
  static Future<void> createBackup({
    required List<Holding> holdings,
    required List<Transaction> transactions,
    required List<CashTransaction> cashTransactions,
  }) async {
    final Map<String, dynamic> backupData = {
      'version': '1.0',
      'timestamp': DateTime.now().toIso8601String(),
      'holdings': holdings.map((h) => (h as HoldingModel).toJson()).toList(),
      'transactions':
          transactions.map((t) => (t as TransactionModel).toJson()).toList(),
      'cashTransactions': cashTransactions
          .map((c) => (c as CashTransactionModel).toJson())
          .toList(),
    };

    final String jsonString = jsonEncode(backupData);
    final Uint8List bytes = Uint8List.fromList(utf8.encode(jsonString));

    await FilePicker.platform.saveFile(
      dialogTitle: 'Save Portfolio Backup',
      fileName:
          'cse_portfolio_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
  }

  static Future<Map<String, dynamic>?> loadBackup() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final String content = await file.readAsString();
      return jsonDecode(content);
    }
    return null;
  }
}
