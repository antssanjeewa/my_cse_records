import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/app/company/models/company.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _instance = FirebaseFirestore.instance;
final CollectionReference _db = _instance.collection('company');

class CompanyService {
  getAllBooks() {
    return _db.snapshots();
  }

  Future<List<Company>> fetchCompanies() async {
    QuerySnapshot querySnapshot = await _db.get();

    return querySnapshot.docs.map((doc) {
      return Company.fromSnapshot(doc);
    }).toList();
  }

  addCompany(Company company) async {
    // Company company = Company(companyName: bookNameController.text, companyCode: authorNameController.text);
    // print(company);
    try {
      _instance.runTransaction((transaction) async {
        await _db.doc().set(company.toJson());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  // updateBook(Company book, String bookName, String authorName) {
  //   try {
  //     _instance.runTransaction((transaction) async {
  //       await transaction.update(book.documentReference, {'bookName': bookName, 'autorName': authorName});
  //     });
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e.toString());
  //   }
  // }

  // deleteBook(Company company) {
  //   _instance.runTransaction((transaction) async {
  //     await transaction.delete(company.documentReference);
  //   });
  // }

  Future<void> deleteCompany(Company company) async {
    if (company.documentReference != null) {
      try {
        await _instance.runTransaction((transaction) async {
          await transaction.delete(company.documentReference);
        });
      } catch (e) {
        print("Error deleting document: $e");
      }
    } else {
      print("Document reference is null.");
    }
  }
}
