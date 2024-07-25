// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/record_provider.dart';
import 'widgets/investment_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordProvider>(context, listen: false);

    // Load initial data
    provider.loadRecords();
    provider.loadCompanies();

    return Scaffold(
      appBar: AppBar(),
      body: Consumer<RecordProvider>(
        builder: (context, provider, child) {
          final totalInvestment = provider.getTotalInvestment();
          final recentRecords = provider.getRecentRecords();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Investment Summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your total balance",
                        style: TextStyle(),
                      ),
                      Text(
                        'Rs ${totalInvestment.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                /// income and expense
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_upward_rounded,
                              size: 25,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Total Incomes",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                "Rs 3,120.00",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_downward_rounded,
                              size: 25,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Total Expenses",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                "Rs 2,260.00",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Investment Trend Chart
                const InvestmentChart(),
                const SizedBox(height: 26),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 11, 1, 146),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Records',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (recentRecords.isEmpty)
                        const Center(child: Text('No recent records available.'))
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentRecords.length,
                          itemBuilder: (context, index) {
                            final record = recentRecords[index];
                            final company = provider.getCompany(record.companyId);

                            return Container(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
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
                      const SizedBox(height: 16),
                      // Recent Records Section

                      // Navigation Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              GoRouter.of(context).go('/records');
                            },
                            child: const Text('View All Records'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              GoRouter.of(context).go('/company');
                            },
                            child: const Text('Manage Companies'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
