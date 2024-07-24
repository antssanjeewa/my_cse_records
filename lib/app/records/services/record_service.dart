import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/app/records/models/record.dart';

final FirebaseFirestore _instance = FirebaseFirestore.instance;
final CollectionReference _db = _instance.collection('records');

class RecordService {
  getRecords() {
    return _db.snapshots();
  }

  getCompanyRecords(String companyCode) {
    return _db.where('company_id', isEqualTo: companyCode).snapshots();
  }

  addNewRecord(Record record) {
    try {
      _instance.runTransaction((transaction) async {
        await _db.doc().set(record.toJson());

        // Update the related company's outcome
        var companyQuerySnapshot = await _instance.collection('company').where('companyCode', isEqualTo: record.companyId).get();

        if (companyQuerySnapshot.docs.isNotEmpty) {
          var companyDoc = companyQuerySnapshot.docs.first;
          var companyReference = companyDoc.reference;

          num price = double.tryParse(record.price ?? '0') ?? 0;
          num quantity = double.tryParse(record.amount ?? '0') ?? 0;

          await transaction.update(companyReference, {
            'outcome': FieldValue.increment(price * quantity), // Increment the 'outcome' field by 100
            'quantity': FieldValue.increment(quantity),
          });
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
