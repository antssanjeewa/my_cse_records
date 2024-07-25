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
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 300,
        child: charts.TimeSeriesChart(
          provider.getInvestmentSeries(),
          animate: true,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          primaryMeasureAxis: const charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
            ),
          ),
          domainAxis: const charts.DateTimeAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
            ),
          ),
        ),
      ),
    );
  }
}
