// lib/screens/records/record_list_screen.dart
import 'package:firebase_app/models/record_model.dart';
import 'package:firebase_app/models/company_model.dart';
import 'package:firebase_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/record_provider.dart';

class RecordsScreen extends StatelessWidget {
  final String? companyId;
  final String? companyName;

  RecordsScreen({this.companyId, this.companyName});

  @override
  Widget build(BuildContext context) {
    final recordProvider = Provider.of<RecordProvider>(context, listen: false);

    // Load records and companies when the screen is built
    recordProvider.loadRecords(companyId: companyId);
    recordProvider.loadCompanies();

    return Scaffold(
      appBar: AppBar(title: Text('$companyName - Records'), actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            GoRouter.of(context).go('/records/add');
          },
        ),
      ]),
      body: Consumer<RecordProvider>(
        builder: (context, provider, child) {
          if (provider.records.isEmpty) {
            return const Center(child: Text('No records available.'));
          }
          return ListView.builder(
            itemCount: provider.records.length,
            itemBuilder: (context, index) {
              final record = provider.records[index];
              final company = provider.getCompany(record.companyId);

              return listItem(record, company!, context);
            },
          );
        },
      ),
    );
  }

  Widget listItem(Record record, Company company, BuildContext context) {
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
          // GoRouter.of(context).go('/companies/edit/${company.id}');
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
      child: recordItem(record, company),
    );
  }

  Card recordItem(Record record, Company? company) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: TColors.primary, borderRadius: BorderRadius.circular(10)),
          child: Text(
            company!.symbol,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(record.transactionType),
        subtitle: Text('Transaction Type: ${record.transactionType}'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unit Price: ${record.unitPrice.toStringAsFixed(2)}'),
            // Text('Total: ${record.total.toStringAsFixed(2)}'),
            if (company != null) Text('Company Code: ${company.symbol}'),
          ],
        ),
        onTap: () {
          // GoRouter.of(context).go('/company/${company.id}');
        },
      ),
    );
  }
}
