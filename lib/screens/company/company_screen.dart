// lib/screens/company/company_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/company_provider.dart';
import 'add_company_screen.dart';

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recordProvider = Provider.of<CompanyProvider>(context, listen: false);

    // Load records and companies when the screen is built
    recordProvider.loadCompanies();

    return Scaffold(
      appBar: AppBar(
        title: Text('Company List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCompanyScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<CompanyProvider>(
        builder: (context, companyProvider, child) {
          if (companyProvider.companies.isEmpty) {
            return Center(child: Text('No companies available.'));
          }
          return ListView.builder(
            itemCount: companyProvider.companies.length,
            itemBuilder: (context, index) {
              final company = companyProvider.companies[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(company.name),
                  subtitle: Text('ID: ${company.id}'),
                  onTap: () {
                    GoRouter.of(context).go('/company/${company.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
