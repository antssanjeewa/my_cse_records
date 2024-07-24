// lib/models/record_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  String id;
  DateTime date;
  double unitPrice;
  double total;
  String companyId;
  String transactionType;

  Record({
    required this.id,
    required this.date,
    required this.unitPrice,
    required this.total,
    required this.companyId,
    required this.transactionType,
  });

  // From Firestore document to model
  factory Record.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return Record(
      id: doc.id,
      // date: (data['date'] as Timestamp).toDate(),
      date: DateTime.parse(data['date'] as String),
      unitPrice: data['unitPrice'] ?? 0.0,
      total: data['total'] ?? 0.0,
      companyId: data['companyId'] ?? '',
      transactionType: data['transactionType'] ?? '',
    );
  }

  // To Firestore document
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'unitPrice': unitPrice,
      'total': total,
      'companyId': companyId,
      'transactionType': transactionType,
    };
  }
}
