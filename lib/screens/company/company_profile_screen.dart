// lib/screens/company/company_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/company_provider.dart';

class CompanyProfileScreen extends StatelessWidget {
  final String companyId;
  final String companyName;

  CompanyProfileScreen({required this.companyId, required this.companyName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompanyProvider()..fetchCompanyById(companyId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('$companyName Profile'),
        ),
        body: Consumer<CompanyProvider>(
          builder: (context, provider, child) {
            final company = provider.company!;
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
      ),
    );
  }
}
