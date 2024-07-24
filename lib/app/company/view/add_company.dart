import 'package:firebase_app/app/company/models/company.dart';
import 'package:firebase_app/app/company/services/companyService.dart';
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
    CompanyService service = CompanyService();
    Company company = Company(companyName: bookNameController.text, companyCode: authorNameController.text);

    service.addCompany(company);
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
