import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/portfolio_viewmodel.dart';
import '../models/holding.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ideally this would be fetched from a provider, but using the one provided by context
    final viewModel = Provider.of<PortfolioViewModel>(context);
    final currencyFormat = NumberFormat.currency(locale: 'en_LK', symbol: 'LKR ');

    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      body: CustomScrollView(
        slivers: [
           // App Bar
           SliverAppBar(
             backgroundColor: const Color(0xFF101322).withOpacity(0.9),
             floating: true,
             pinned: true,
             elevation: 0,
             title: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('CSE Portfolio', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                 Text('MARKET OPEN', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey, letterSpacing: 1.5)),
               ],
             ),
             actions: [
               Padding(
                 padding: const EdgeInsets.only(right: 16.0),
                 child: CircleAvatar(
                   backgroundColor: const Color(0xFF232948),
                   child: Stack(
                     children: [
                       const Icon(Icons.notifications, color: Colors.white, size: 20),
                       Positioned(top: 2, right: 2, child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
                     ],
                   ),
                 ),
               ),
             ],
           ),
           
           SliverToBoxAdapter(
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(
                 children: [
                    // Hero Card
                    _buildHeroCard(viewModel, currencyFormat),
                    const SizedBox(height: 24),
                    // Chart
                    _buildChartSection(),
                    const SizedBox(height: 24),
                    // Asset Allocation
                    _buildAssetAllocation(),
                    const SizedBox(height: 24),
                    // Top Holdings
                    _buildTopHoldings(viewModel, currencyFormat),
                 ],
               ),
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(PortfolioViewModel viewModel, NumberFormat fmt) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1337EC),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1337EC).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Portfolio Value', style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(fmt.format(viewModel.totalValue), style: GoogleFonts.inter(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.greenAccent, size: 16),
                    const SizedBox(width: 4),
                    Text('+LKR 15,200.50 (2.5%)', style: GoogleFonts.inter(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('Today', style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF191E33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF323B67)),
      ),
      child: Column(
        children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('Performance History', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
               Row(
                 children: [
                   _buildChartTab('30D', true),
                   _buildChartTab('6M', false),
                   _buildChartTab('1Y', false),
                 ],
               )
             ],
           ),
           const SizedBox(height: 24),
           SizedBox(
             height: 150,
             child: LineChart(
               LineChartData(
                 gridData: FlGridData(show: false),
                 titlesData: FlTitlesData(
                   show: true,
                   rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   bottomTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       getTitlesWidget: (value, meta) {
                         switch (value.toInt()) {
                           case 0: return const Text('MAY 01', style: TextStyle(color: Colors.grey, fontSize: 10));
                           case 6: return const Text('MAY 15', style: TextStyle(color: Colors.grey, fontSize: 10));
                           case 11: return const Text('TODAY', style: TextStyle(color: Colors.grey, fontSize: 10));
                         }
                         return const Text('');
                       },
                       interval: 1,
                     ),
                   ),
                 ),
                 borderData: FlBorderData(show: false),
                 minX: 0, maxX: 11,
                 minY: 0, maxY: 6,
                 lineBarsData: [
                   LineChartBarData(
                     spots: [
                       const FlSpot(0, 3), const FlSpot(2, 2), const FlSpot(4, 5),
                       const FlSpot(6, 3.1), const FlSpot(8, 4), const FlSpot(9.5, 3), const FlSpot(11, 4),
                     ],
                     isCurved: true,
                     color: const Color(0xFF1337EC),
                     barWidth: 3,
                     isStrokeCapRound: true,
                     dotData: FlDotData(show: false),
                     belowBarData: BarAreaData(
                       show: true,
                       gradient: LinearGradient(
                         colors: [
                           const Color(0xFF1337EC).withOpacity(0.3),
                           const Color(0xFF1337EC).withOpacity(0.0),
                         ],
                         begin: Alignment.topCenter,
                         end: Alignment.bottomCenter,
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildChartTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF323B67) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey, 
          fontSize: 12, fontWeight: FontWeight.bold
      )),
    );
  }

  Widget _buildAssetAllocation() {
     return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF191E33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF323B67)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Asset Allocation', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                height: 100, width: 100,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(value: 75, color: const Color(0xFF1337EC), radius: 15, showTitle: false),
                      PieChartSectionData(value: 20, color: Colors.grey, radius: 15, showTitle: false),
                      PieChartSectionData(value: 5, color: Colors.white, radius: 15, showTitle: false),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem(color: const Color(0xFF1337EC), label: 'Stocks', pct: '75%'),
                    _buildLegendItem(color: Colors.grey, label: 'Cash', pct: '20%'),
                    _buildLegendItem(color: Colors.white, label: 'Other', pct: '5%'),
                  ],
                ),
              )
            ],
          )
        ],
      ),
     );
  }

  Widget _buildLegendItem({required Color color, required String label, required String pct}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            CircleAvatar(radius: 4, backgroundColor: color),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          Text(pct, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTopHoldings(PortfolioViewModel vm, NumberFormat fmt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text('Top 5 Holdings', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
             Text('VIEW ALL', style: GoogleFonts.inter(color: const Color(0xFF1337EC), fontSize: 12, fontWeight: FontWeight.bold)),
           ],
        ),
        const SizedBox(height: 12),
        ...vm.holdings.take(5).map((h) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
            color: const Color(0xFF191E33),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF323B67)),
          ),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: const Color(0xFF232948), borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Text(h.ticker.split('.')[0], style: const TextStyle(color: Color(0xFF1337EC), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(h.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('${h.quantity.toInt()} Shares', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(fmt.format(h.marketPrice), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('${h.profitPercent > 0 ? '+' : ''}${h.profitPercent.toStringAsFixed(1)}%', 
                    style: TextStyle(color: h.profitPercent >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)
                  ),
                ],
              )
            ],
          ),
        )),
      ],
    );
  }
}
