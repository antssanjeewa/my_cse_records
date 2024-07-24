import 'package:firebase_app/app/company/models/company.dart';
import 'package:firebase_app/app/company/services/companyService.dart';
import 'package:firebase_app/app/records/models/record.dart';
import 'package:firebase_app/app/records/services/record_service.dart';
import 'package:firebase_app/utils/constants/sizes.dart';
import 'package:firebase_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddRecordDialog extends StatefulWidget {
  const AddRecordDialog({super.key});

  @override
  State<AddRecordDialog> createState() => _AddRecordDialogState();
}

class _AddRecordDialogState extends State<AddRecordDialog> {
  TextEditingController typeController = TextEditingController(text: 'expense');
  TextEditingController dateController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController companyIdController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final List<bool> _selectedType = <bool>[false, true, false];

  CompanyService companyService = CompanyService();

  FormValidator validator = FormValidator();

  List<Company> companies = [];
  Company? selectCompany;

  addRecord() async {
    RecordService service = RecordService();

    Record record = Record(
      type: typeController.text,
      date: dateController.text,
      amount: quantityController.text,
      companyId: companyIdController.text,
      price: priceController.text,
    );

    service.addNewRecord(record);

    Navigator.pop(context);
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

  getSelectedColor() {
    switch (typeController.text) {
      case 'income':
        return Colors.green[800];
      case 'expense':
        return Colors.red[800];
      case 'dividend':
        return Colors.orange[800];
      default:
        return Colors.blue[800];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ToggleButtons(
            isSelected: _selectedType,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedColor: Colors.white,
            fillColor: getSelectedColor(),
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 100.0,
            ),
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _selectedType.length; i++) {
                  _selectedType[i] = i == index;
                  typeController.text = ['income', 'expense', 'dividend'][index];
                }
              });
            },
            children: const <Widget>[
              Text('Income'),
              Text('Expense'),
              Text('Dividend'),
            ],
          ),

          //
          const SizedBox(height: TSizes.spaceBtwItems),
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

          //
          const SizedBox(height: TSizes.spaceBtwItems),
          DropdownButtonFormField(
            items: companies.map((Company company) {
              return DropdownMenuItem<Company>(
                value: company,
                child: Text(company.companyName ?? ''),
              );
            }).toList(),
            value: selectCompany,
            hint: const Text('Company Name'),
            isExpanded: true,
            onChanged: ((Company? company) {
              setState(() {
                selectCompany = company;
              });
              companyIdController.text = company?.companyCode ?? '';
            }),
          ),

          //
          const SizedBox(height: TSizes.spaceBtwItems),
          TextFormField(
            controller: quantityController,
            validator: validator.validateIsEmpty,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.money),
              labelText: "Quantity",
              contentPadding: EdgeInsets.all(15),
              hintText: "Ex: 100",
            ),
          ),

          //
          const SizedBox(height: TSizes.spaceBtwItems),
          TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.money),
              labelText: "Unit Price",
              contentPadding: EdgeInsets.all(15),
              hintText: "Ex: 12.5",
            ),
          ),

          //
          const SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text("Add Record"),
              onPressed: () => addRecord(),
            ),
          ),
        ],
      ),
    );
  }
}
