// lib/providers/record_provider.dart
import 'package:flutter/material.dart';
import '../models/company_model.dart';
import '../models/record_model.dart';
import '../services/firestore_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RecordProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Record> _records = [];
  Map<String, Company> _companies = {};

  List<Record> get records => _records;

  void loadRecords({String? companyId}) {
    if (companyId != null) {
      _firestoreService.getRecords(companyId).listen((records) {
        _records = records;
        notifyListeners();
      });
    } else {
      _firestoreService.getAllRecords().listen((records) {
        _records = records;
        notifyListeners();
      });
    }
  }

  // Future<void> addRecord(Record record) async {
  //   await _firestoreService.addRecord(record);
  // }

  Future<void> addRecord(Record record) async {
    await _firestoreService.addRecordAndUpdateStats(record);
    notifyListeners();
  }

  void loadCompanies() {
    _firestoreService.getCompanies().listen((companies) {
      _companies = {for (var company in companies) company.id: company};
      notifyListeners();
    });
  }

  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Company? getCompany(String companyId) => _companies[companyId];
  // Add other CRUD operations as needed

  double getTotalInvestment() {
    return _records.fold(0.0, (sum, record) => sum + record.total);
  }

  List<Record> getRecentRecords({int count = 5}) {
    return _records.take(count).toList();
  }

  List<charts.Series<Record, DateTime>> getInvestmentSeries() {
    return [
      charts.Series<Record, DateTime>(
        id: 'Investments',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Record record, _) => record.date,
        measureFn: (Record record, _) => record.total,
        data: _records,
      )
    ];
  }
}
