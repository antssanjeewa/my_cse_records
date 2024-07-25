// lib/screens/company/add_edit_company_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/record_provider.dart';
import '../../models/company_model.dart';

class AddEditCompanyScreen extends StatefulWidget {
  final String? companyId;

  AddEditCompanyScreen({this.companyId});

  @override
  _AddEditCompanyScreenState createState() => _AddEditCompanyScreenState();
}

class _AddEditCompanyScreenState extends State<AddEditCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _symbol;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.companyId != null;
    if (_isEditing) {
      final provider = Provider.of<RecordProvider>(context, listen: false);
      final company = provider.getCompany(widget.companyId!);
      _name = company!.name;
      _symbol = company.symbol;
    } else {
      _name = '';
      _symbol = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Company' : 'Add Company'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _symbol,
                decoration: InputDecoration(labelText: 'Symbol'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company symbol';
                  }
                  return null;
                },
                onSaved: (value) {
                  _symbol = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  //   _formKey.currentState!.save();
                  //   // if (_isEditing) {
                  //   //   // provider.updateCompany(widget.companyId!, _name, _symbol);
                  //   // } else {
                  //   //   // provider.addCompany(_name, _symbol);
                  //   // }
                  //   GoRouter.of(context).pop();
                  // }
                },
                child: Text(_isEditing ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
