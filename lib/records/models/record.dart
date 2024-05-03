import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  String? type;
  String? date;
  String? amount;
  String? companyId;
  String? price;

  late DocumentReference documentReference;

  Record({this.companyId, this.date, this.amount, this.price, this.type});

  Record.fromMap(Map<String, dynamic> map, {required this.documentReference}) {
    type = map["type"];
    date = map["date"];
    amount = map["amount"];
    companyId = map["company_id"];
    price = map["price"];
  }

  Record.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data()! as Map<String, dynamic>, documentReference: snapshot.reference);

  toJson() {
    return {
      'type': type,
      'date': date,
      'amount': amount,
      'company_id': companyId,
      'price': price,
    };
  }
}
