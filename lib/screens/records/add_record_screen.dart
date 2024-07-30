// lib/screens/records/add_record_screen.dart
import 'package:firebase_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/record_model.dart';
import '../../providers/company_provider.dart';
import '../../providers/record_provider.dart';

class AddRecordScreen extends StatefulWidget {
  final String? companyId;

  AddRecordScreen({this.companyId});

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _date = DateTime.now();

  TextEditingController typeController = TextEditingController(text: 'expense');
  TextEditingController dateController = TextEditingController(text: DateTime.now().toString().substring(0, 10));
  TextEditingController quantityController = TextEditingController();
  TextEditingController companyIdController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final List<bool> _selectedType = <bool>[false, true, false];

  double _unitPrice = 0.0;
  double _total = 0.0;
  int _quantity = 0;
  String? _selectedCompanyId;

  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.companyId != null;
    if (_isEditing) {
      final provider = Provider.of<RecordProvider>(context, listen: false);
      // company = provider.getCompany(widget.companyId!);
      // _nameController.text = company!.name;
      // _symbolController.text = company!.symbol;
    }

    Provider.of<CompanyProvider>(context, listen: false).loadCompanies();
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final record = Record(
        id: '', // Let Firestore generate the ID
        companyId: _selectedCompanyId!,
        // companyId: widget.companyId  1,
        date: _date,
        quantity: _quantity,
        unitPrice: _unitPrice,
        total: _total,
        transactionType: typeController.text,
      );
      //    Record record = Record(
      //     id: '',
      //   transactionType: typeController.text,
      //   date: dateController.text,
      //   quantity: quantityController.text,
      //   companyId: companyIdController.text,
      //   unitPrice: priceController.text,
      //   total: _total,
      // );

      Provider.of<RecordProvider>(context, listen: false).addRecord(record);
      Navigator.pop(context); // Go back after adding the record
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Add Record'),
        backgroundColor: TColors.primary,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              color: TColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              _isEditing ? 'Update Record' : 'Add New Record',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          //Form
          Consumer<CompanyProvider>(builder: (context, companyProvider, child) {
            return Padding(
              padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: formContent(companyProvider, context),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Form formContent(CompanyProvider companyProvider, BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ToggleButtons(
            isSelected: _selectedType,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedColor: Colors.white,
            fillColor: getSelectedColor(),
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 100,
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
          const SizedBox(height: 25),

          //
          DropdownButtonFormField<String>(
            value: _selectedCompanyId,
            decoration: const InputDecoration(labelText: 'Company'),
            onChanged: (value) {
              setState(() {
                _selectedCompanyId = value;
              });
            },
            items: companyProvider.companies.map((company) {
              return DropdownMenuItem(
                value: company.id,
                child: Text(company.name),
              );
            }).toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a company';
              }
              return null;
            },
          ),

          const SizedBox(height: 25),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Unit Price'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _unitPrice = double.tryParse(value) ?? 0.0;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the unit price';
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _quantity = int.tryParse(value) ?? 0;
              _total = _unitPrice * _quantity;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the quantity amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Date'),
            // initialValue: _date.toLocal().toString(),
            controller: dateController,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && pickedDate != _date) {
                setState(() {
                  _date = pickedDate;
                  dateController.text = pickedDate.toLocal().toString().substring(0, 10);
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a date';
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          Text(_total.toString()),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text('Add Record'),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringCapitalization on String {
  String capitalize() => this[0].toUpperCase() + this.substring(1);
}
