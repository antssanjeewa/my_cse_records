import "package:cloud_firestore/cloud_firestore.dart";

class Company {
  String? companyName;
  String? companyCode;
  String? documentId;
  int? quantity;
  double? income;
  double? outcome;
  double? dividend;

  late DocumentReference documentReference;

  Company({
    this.companyName,
    this.companyCode,
    this.quantity = 0,
    this.outcome = 0.0,
    DocumentReference? documentReference,
  }) {
    documentId = documentReference?.id;
  }

  Company.fromMap(Map<String, dynamic> map, {required this.documentReference}) {
    companyName = map["companyName"];
    companyCode = map["companyCode"];
    quantity = map["quantity"].toInt() ?? 0;
    outcome = map["outcome"] ?? 0.0;
    documentId = documentReference.id;
  }

  Company.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data()! as Map<String, dynamic>, documentReference: snapshot.reference);

  toJson() {
    return {"companyName": companyName, "companyCode": companyCode};
  }

  double get averagePrice {
    if (quantity != null && quantity! > 0) {
      double netIncome = (outcome ?? 0) - (income ?? 0);

      return netIncome / quantity!;
    } else {
      return 0;
    }
  }
}
