import "package:cloud_firestore/cloud_firestore.dart";

class Book {
  String? bookName;
  String? autorName;

  late DocumentReference documentReference;

  Book({this.bookName, this.autorName});

  Book.fromMap(Map<String, dynamic> map, {required this.documentReference}) {
    bookName = map["bookName"];
    autorName = map["autorName"];
  }

  Book.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data()! as Map<String, dynamic>, documentReference: snapshot.reference);

  toJson() {
    return {"bookName": bookName, "autorName": autorName};
  }
}
