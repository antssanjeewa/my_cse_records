import "package:cloud_firestore/cloud_firestore.dart";

class Company {
  String? companyName;
  String? companyCode;

  late DocumentReference documentReference;

  Company({this.companyName, this.companyCode});

  Company.fromMap(Map<String, dynamic> map, {required this.documentReference}) {
    companyName = map["companyName"];
    companyCode = map["companyCode"];
  }

  Company.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data()! as Map<String, dynamic>, documentReference: snapshot.reference);

  toJson() {
    return {"companyName": companyName, "companyCode": companyCode};
  }
}
