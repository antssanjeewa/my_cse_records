import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/records/models/record.dart';

final FirebaseFirestore _instance = FirebaseFirestore.instance;
final CollectionReference _db = _instance.collection('records');

class RecordService {
  getRecords() {
    return _db.snapshots();
  }

  addNewRecord(Record record) {
    try {
      _instance.runTransaction((transaction) async {
        await _db.doc().set(record.toJson());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
