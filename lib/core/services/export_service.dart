import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/transaction.dart';

class ExportService {
  static Future<void> exportTransactionsToCsv(
      List<Transaction> transactions, String monthYear) async {
    List<List<dynamic>> csvData = [
      // Headers
      [
        'Date',
        'Ticker',
        'Company',
        'Type',
        'Quantity',
        'Price (LKR)',
        'Total (LKR)'
      ],
    ];

    for (var tx in transactions) {
      csvData.add([
        DateFormat('yyyy-MM-dd').format(tx.date),
        tx.ticker,
        tx.name,
        tx.typeString,
        tx.qty,
        tx.unitPrice,
        tx.totalPrice,
      ]);
    }

    // 1. Convert data to CSV string
    String csvString = csv.encode(csvData);

    // 2. Convert string to bytes
    Uint8List bytes = Uint8List.fromList(csvString.codeUnits);

    // 3. Open the "Save As" system dialog (Downloads, Drive, etc.)
    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Trade History',
      fileName: 'trade_history_$monthYear.csv',
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    // 4. If the user didn't cancel, ensure file is written
    // Note: On some platforms (Web/Windows/Desktop), bytes in saveFile handles it.
    // On Android/iOS, we might need manual write if outputPath is returned.
    if (outputPath != null && bytes.isNotEmpty) {
      final file = File(outputPath);
      await file.writeAsBytes(bytes);
    }
  }
}
