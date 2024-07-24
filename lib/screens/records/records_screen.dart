// lib/screens/records/record_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/record_provider.dart';
import 'add_record_screen.dart';

class RecordsScreen extends StatelessWidget {
  final String? companyId;
  final String? companyName;

  RecordsScreen({this.companyId, this.companyName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecordProvider()..loadRecords(companyId: companyId),
      child: Scaffold(
        appBar: AppBar(title: Text('$companyName - Records'), actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).go('/records/add');
            },
          ),
        ]),
        body: Consumer<RecordProvider>(
          builder: (context, provider, child) {
            if (provider.records.isEmpty) {
              return Center(child: Text('No records available.'));
            }
            return ListView.builder(
              itemCount: provider.records.length,
              itemBuilder: (context, index) {
                final record = provider.records[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text('Date: ${record.date.toLocal()}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Unit Price: ${record.unitPrice.toStringAsFixed(2)}'),
                        Text('Total: ${record.total.toStringAsFixed(2)}'),
                        Text('Transaction Type: ${record.transactionType}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
