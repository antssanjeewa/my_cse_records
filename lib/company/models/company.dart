import "package:cloud_firestore/cloud_firestore.dart";

class Company {
  String? companyName;
  String? companyCode;
  String? documentId;

  late DocumentReference documentReference;

  Company({this.companyName, this.companyCode, DocumentReference? documentReference}) {
    documentId = documentReference?.id;
  }

  Company.fromMap(Map<String, dynamic> map, {required this.documentReference}) {
    companyName = map["companyName"];
    companyCode = map["companyCode"];
    documentId = documentReference.id;
  }

  Company.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data()! as Map<String, dynamic>, documentReference: snapshot.reference);

  toJson() {
    return {"companyName": companyName, "companyCode": companyCode};
  }
}
