import 'package:firebase_app/records/models/record.dart';
import 'package:firebase_app/records/services/record_service.dart';
import 'package:flutter/material.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({super.key});

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController companyIdController = TextEditingController();

  addRecord() async {
    RecordService service = RecordService();
    Record record = Record(
      date: bookNameController.text,
      amount: authorNameController.text,
      companyId: companyIdController.text,
    );

    service.addNewRecord(record);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Record"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          TextFormField(
            controller: bookNameController,
            decoration: InputDecoration(labelText: "Date", hintText: "Enter Book Name"),
          ),
          TextFormField(
            controller: authorNameController,
            decoration: InputDecoration(labelText: "Amount", hintText: "Enter Author Name"),
          ),
          TextFormField(
            controller: companyIdController,
            decoration: InputDecoration(labelText: "Company", hintText: "Enter Author Name"),
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(child: Text("Add"), onPressed: () => addRecord())
        ]),
      ),
    );
  }
}
