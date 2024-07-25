// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/record_provider.dart';
import 'widgets/investment_chart.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordProvider>(context, listen: false);

    // Load initial data
    provider.loadRecords();
    provider.loadCompanies();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Investments'),
      ),
      body: Consumer<RecordProvider>(
        builder: (context, provider, child) {
          final totalInvestment = provider.getTotalInvestment();
          final recentRecords = provider.getRecentRecords();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Investment Summary
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Investment',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$${totalInvestment.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Investment Trend Chart
                  InvestmentChart(),
                  SizedBox(height: 16),

                  // Recent Records Section
                  Text(
                    'Recent Records',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (recentRecords.isEmpty)
                    Center(child: Text('No recent records available.'))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: recentRecords.length,
                      itemBuilder: (context, index) {
                        final record = recentRecords[index];
                        final company = provider.getCompany(record.companyId);

                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text('Date: ${record.date.toLocal()}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Unit Price: ${record.unitPrice.toStringAsFixed(2)}'),
                                Text('Total: ${record.total.toStringAsFixed(2)}'),
                                Text('Transaction Type: ${record.transactionType}'),
                                if (company != null) Text('Company: ${company.name} (${company.symbol})'),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 16),

                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).go('/records');
                        },
                        child: Text('View All Records'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).go('/company');
                        },
                        child: Text('Manage Companies'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
