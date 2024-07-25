// lib/screens/company/company_list_screen.dart
import 'package:firebase_app/models/company_model.dart';
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
        title: const Text('Company List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
            return const Center(child: Text('No companies available.'));
          }
          return ListView.builder(
            itemCount: companyProvider.companies.length,
            itemBuilder: (context, index) {
              final company = companyProvider.companies[index];
              return listItem(company, context);
            },
          );
        },
      ),
    );
  }

  Widget listItem(Company company, BuildContext context) {
    return Dismissible(
      key: Key(company.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirm = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Confirm Deletion'),
                content: Text('Are you sure you want to delete ${company.name}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
          return confirm ?? false;
        } else if (direction == DismissDirection.endToStart) {
          GoRouter.of(context).go('/companies/edit/${company.id}');
          return false; // Do not dismiss the item
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Delete action
          // provider.deleteCompany(company.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${company.name} deleted')),
          );
        } else if (direction == DismissDirection.endToStart) {
          // Edit action
          GoRouter.of(context).go('/companies/edit/${company.id}');
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(company.name),
          subtitle: Text('ID: ${company.id}'),
          onTap: () {
            GoRouter.of(context).go('/company/${company.id}');
          },
        ),
      ),
    );
  }
}
