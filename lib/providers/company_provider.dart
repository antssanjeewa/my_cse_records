import 'package:flutter/material.dart';
import '../models/company_model.dart';
import '../services/firestore_service.dart';

class CompanyProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Company> _companies = [];

  List<Company> get companies => _companies;

  void loadCompanies() {
    _firestoreService.getCompanies().listen((companies) {
      _companies = companies;
      notifyListeners();
    });
  }

  Company? _company;
  Company? get company => _company;

  Future<void> addCompany(Company company) async {
    await _firestoreService.addCompany(company);
  }

  Future<void> updateCompany(Company company) async {
    await _firestoreService.updateCompany(company);
  }

  Future<void> fetchCompanyById(String companyId) async {
    _company = await _firestoreService.getCompanyById(companyId);
    notifyListeners();
  }
  // Add other CRUD operations as needed
}
