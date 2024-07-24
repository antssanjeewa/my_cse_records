// lib/screens/records/add_record_screen.dart
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
  double _unitPrice = 0.0;
  double _total = 0.0;
  String _transactionType = 'buy'; // Default to 'buy'
  String? _selectedCompanyId;

  @override
  void initState() {
    super.initState();
    Provider.of<CompanyProvider>(context, listen: false).loadCompanies();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final record = Record(
        id: '', // Let Firestore generate the ID
        companyId: _selectedCompanyId!,
        // companyId: widget.companyId  1,
        date: _date,
        unitPrice: _unitPrice,
        total: _total,
        transactionType: _transactionType,
      );
      Provider.of<RecordProvider>(context, listen: false).addRecord(record);
      Navigator.pop(context); // Go back after adding the record
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Record'),
      ),
      body: Consumer<CompanyProvider>(builder: (context, companyProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Date'),
                  initialValue: _date.toLocal().toString(),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _date) {
                      setState(() {
                        _date = pickedDate;
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
                SizedBox(height: 15),
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
                SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Total'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _total = double.tryParse(value) ?? 0.0;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the total amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _transactionType,
                  decoration: const InputDecoration(labelText: 'Transaction Type'),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _transactionType = value;
                      });
                    }
                  },
                  items: ['buy', 'sell'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.capitalize()),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a transaction type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Add Record'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

extension StringCapitalization on String {
  String capitalize() => this[0].toUpperCase() + this.substring(1);
}
