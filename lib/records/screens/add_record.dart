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

  CompanyService companyService = CompanyService();

  addRecord() async {
    RecordService service = RecordService();

    Record record = Record(
      date: dateController.text,
      amount: authorNameController.text,
      companyId: companyIdController.text,
    );

    service.addNewRecord(record);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Record"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
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
            decoration: const InputDecoration(labelText: "Amount", hintText: "Enter Author Name"),
          ),
          TextFormField(
            controller: companyIdController,
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(labelText: "Company", hintText: "Enter Author Name"),
          ),
          DropdownButton(
            items: companyService.itemList().map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            value: companyIdController.text,
            hint: Text('Company Name'),
            isExpanded: true,
            onChanged: ((value) {
              companyIdController.text = value.toString();
            }),
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton(child: const Text("Add"), onPressed: () => addRecord())
        ]),
      ),
    );
  }
}
