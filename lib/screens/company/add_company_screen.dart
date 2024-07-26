import 'package:firebase_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../../providers/company_provider.dart';
import '../../models/company_model.dart';
import '../../providers/record_provider.dart';

class AddCompanyScreen extends StatefulWidget {
  final String? companyId;

  const AddCompanyScreen({this.companyId});

  @override
  _AddCompanyScreenState createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  Color _selectedColor = Colors.blue;
  late bool _isEditing;
  late Company? company;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.companyId != null;
    if (_isEditing) {
      final provider = Provider.of<RecordProvider>(context, listen: false);
      company = provider.getCompany(widget.companyId!);
      _nameController.text = company!.name;
      _symbolController.text = company!.symbol;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newCompany = Company(
        id: company != null ? company!.id : '', // Firestore will generate the ID
        name: _nameController.text,
        symbol: _symbolController.text,
        color: _colorToHex(_selectedColor),
      );
      if (_isEditing) {
        Provider.of<CompanyProvider>(context, listen: false).updateCompany(newCompany);
      } else {
        Provider.of<CompanyProvider>(context, listen: false).addCompany(newCompany);
      }

      Navigator.pop(context); // Go back after adding the company
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Add Company'),
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
              _isEditing ? 'Update Company' : 'Add New Company',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          //Form
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 50),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Company Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the company name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _symbolController,
                        decoration: const InputDecoration(labelText: 'Symbol'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the company symbol';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text('Select Color:'),
                      GestureDetector(
                        onTap: () {
                          _showColorPicker(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
