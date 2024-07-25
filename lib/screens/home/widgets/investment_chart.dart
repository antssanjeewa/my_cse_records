// lib/widgets/investment_chart.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../../providers/record_provider.dart';

class InvestmentChart extends StatelessWidget {
  const InvestmentChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordProvider>(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Investment Trend',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: charts.TimeSeriesChart(
                provider.getInvestmentSeries(),
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
