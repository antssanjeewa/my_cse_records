// lib/providers/record_provider.dart
import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../services/firestore_service.dart';

class RecordProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Record> _records = [];

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

  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add other CRUD operations as needed
}
