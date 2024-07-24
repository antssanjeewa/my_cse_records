// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/company_model.dart';
import '../models/record_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch companies
  Stream<List<Company>> getCompanies() {
    return _db.collection('company').snapshots().map((snapshot) => snapshot.docs.map((doc) => Company.fromFirestore(doc)).toList());
  }

  // Fetch records for a specific company
  Stream<List<Record>> getRecords(String companyId) {
    return _db.collection('records').where('companyId', isEqualTo: companyId).snapshots().map((snapshot) => snapshot.docs.map((doc) => Record.fromFirestore(doc)).toList());
  }

  Stream<List<Record>> getAllRecords() {
    return _db.collection('records').snapshots().map((snapshot) => snapshot.docs.map((doc) => Record.fromFirestore(doc)).toList());
  }

  // Add company
  Future<void> addCompany(Company company) {
    return _db.collection('companies').add(company.toMap());
  }

  // Add record
  Future<void> addRecord(Record record) {
    return _db.collection('records').add(record.toMap());
  }

  // Update company
  Future<void> updateCompany(Company company) {
    return _db.collection('companies').doc(company.id).update(company.toMap());
  }

  // Update record
  Future<void> updateRecord(Record record) {
    return _db.collection('records').doc(record.id).update(record.toMap());
  }

  // Delete company
  Future<void> deleteCompany(String companyId) {
    return _db.collection('companies').doc(companyId).delete();
  }

  // Delete record
  Future<void> deleteRecord(String recordId) {
    return _db.collection('records').doc(recordId).delete();
  }

  // Fetch a specific company by ID
  Future<Company> getCompanyById(String companyId) async {
    final doc = await _db.collection('companies').doc(companyId).get();
    return Company.fromFirestore(doc);
  }

  // Add a record and update company stats
  Future<void> addRecordAndUpdateStats(Record record) async {
    final companyDoc = _db.collection('companies').doc(record.companyId);
    final recordDoc = _db.collection('records').doc();

    await _db.runTransaction((transaction) async {
      final companySnapshot = await transaction.get(companyDoc);
      if (!companySnapshot.exists) {
        throw Exception("Company does not exist!");
      }

      final companyData = companySnapshot.data()!;
      double totalBuyShares = companyData['totalBuyShares'] ?? 0;
      double totalSellShares = companyData['totalSellShares'] ?? 0;
      double totalBuyAmount = companyData['totalBuyAmount'] ?? 0;
      double availableShares = totalBuyShares - totalSellShares;

      if (record.transactionType == 'buy') {
        totalBuyShares += record.total / record.unitPrice;
        totalBuyAmount += record.total;
      } else if (record.transactionType == 'sell') {
        totalSellShares += record.total / record.unitPrice;
      }

      availableShares = totalBuyShares - totalSellShares;
      double avgSharePrice = totalBuyAmount / totalBuyShares;
      double currentShareValue = availableShares * avgSharePrice; // Placeholder for actual current value

      transaction.set(recordDoc, record.toMap());
      transaction.update(companyDoc, {
        'totalBuyShares': totalBuyShares,
        'totalSellShares': totalSellShares,
        'availableShares': availableShares,
        'avgSharePrice': avgSharePrice,
        'currentShareValue': currentShareValue,
      });
    });
  }
}
