// lib/screens/company/company_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/company_provider.dart';

class CompanyProfileScreen extends StatelessWidget {
  final String companyId;
  final String? companyName;

  CompanyProfileScreen({required this.companyId, this.companyName});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context, listen: false);
    provider.fetchCompanyById(companyId);

    return Consumer<CompanyProvider>(builder: (context, provider, child) {
      final company = provider.company;
      if (company == null) {
        return Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        appBar: AppBar(title: Text('${company.name} Profile')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                company.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Symbol: ${company.symbol}',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),

              // Summary Card
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Total Shares: 100'),
                      Text('Average Price: 12'),
                      Text('Current Price: 12'),
                      Text('Current Value: 12'),
                    ],
                  ),
                ),
              ),

              // Detailed Information Card
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Name: ${company.name}'),
                      Text('Symbol: ${company.symbol}'),
                      // Add more detailed information here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Consumer<CompanyProvider>(
        builder: (context, provider, child) {
          final company = provider.company;
          if (company == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Buy Shares: ${company.totalBuyShares}'),
                Text('Total Sell Shares: ${company.totalSellShares}'),
                Text('Available Shares: ${company.availableShares}'),
                Text('Average Share Price: ${company.avgSharePrice.toStringAsFixed(2)}'),
                Text('Current Share Value: ${company.currentShareValue.toStringAsFixed(2)}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
