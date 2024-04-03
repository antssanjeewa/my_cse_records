import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/company/models/company.dart';
import 'package:flutter/material.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();

  addCompany() async {
    Company company = Company(companyName: bookNameController.text, companyCode: authorNameController.text);
    print(company);
    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await FirebaseFirestore.instance.collection('company').doc().set(company.toJson());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Company"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          TextFormField(
            controller: bookNameController,
            decoration: InputDecoration(labelText: "Book Name", hintText: "Enter Book Name"),
          ),
          TextFormField(
            controller: authorNameController,
            decoration: InputDecoration(labelText: "Author Name", hintText: "Enter Author Name"),
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(child: Text("Add"), onPressed: () => addCompany())
        ]),
      ),
    );
  }
}
