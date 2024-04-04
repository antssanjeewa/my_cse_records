import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  String? date;
  String? amount;
  String? companyId;

  late DocumentReference documentReference;

  Record({this.companyId, this.date, this.amount});

  Record.fromMap(Map<String, dynamic> map, {required this.documentReference}) {
    date = map["date"];
    amount = map["amount"];
    companyId = map["company_id"];
  }

  Record.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data()! as Map<String, dynamic>, documentReference: snapshot.reference);

  toJson() {
    return {'date': date, 'amount': amount, 'company_id': companyId};
  }
}
