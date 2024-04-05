import 'package:firebase_app/company/models/company.dart';
import 'package:firebase_app/company/services/companyService.dart';
import 'package:firebase_app/records/models/record.dart';
import 'package:firebase_app/records/services/record_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({super.key});

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  TextEditingController dateController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController companyIdController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  CompanyService companyService = CompanyService();

  List<Company> companies = [];
  Company? selectCompany;

  addRecord() async {
    RecordService service = RecordService();

    Record record = Record(
      date: dateController.text,
      amount: authorNameController.text,
      companyId: companyIdController.text,
      price: priceController.text,
    );

    service.addNewRecord(record);
  }

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    List<Company> fetchedCompanies = await companyService.fetchCompanies();
    setState(() {
      companies.addAll(fetchedCompanies);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Record"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(children: [
          TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_today),
              labelText: "Date",
              hintText: "Enter Book Name",
            ),
            readOnly: true,
            onTap: () async {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );

              if (date == null) return;
              dateController.text = DateFormat('yyyy-MM-dd').format(date);
            },
          ),
          TextFormField(
            controller: authorNameController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.money),
              labelText: "Amount",
              contentPadding: EdgeInsets.all(15),
              hintText: "Enter Author Name",
            ),
          ),
          TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.money),
              labelText: "Price",
              contentPadding: EdgeInsets.all(15),
              hintText: "Enter Author Name",
            ),
          ),
          TextFormField(
            controller: companyIdController,
            keyboardType: TextInputType.datetime,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Company",
              hintText: "Enter Author Name",
            ),
          ),
          const SizedBox(height: 15),
          DropdownButton(
            items: companies.map((Company company) {
              return DropdownMenuItem<Company>(
                value: company,
                child: Text(company.companyName ?? ''),
              );
            }).toList(),
            value: selectCompany,
            hint: Text('Company Name'),
            isExpanded: true,
            onChanged: ((Company? company) {
              setState(() {
                selectCompany = company;
              });
              companyIdController.text = company?.documentId ?? '';
            }),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text("Add New Record"),
            onPressed: () => addRecord(),
          )
        ]),
      ),
    );
  }
}
