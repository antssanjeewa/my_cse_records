import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/routing/pages.dart';
import '../viewmodels/home_viewmodel.dart';
import '../../domain/entities/holding.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading || viewModel.summary == null) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          final summary = viewModel.summary!;

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: AppColors.background.withValues(alpha: 0.9),
                floating: true,
                pinned: true,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.appName,
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    Text('MARKET OPEN',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            letterSpacing: 1.5)),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppSizes.p16),
                    child: CircleAvatar(
                      backgroundColor: AppColors.surfaceLight,
                      child: Stack(
                        children: [
                          const Icon(Icons.notifications,
                              color: Colors.white, size: AppSizes.iconMd),
                          Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    children: [
                      // Hero Card
                      _buildHeroCard(summary.totalValue, summary.load),
                      const SizedBox(height: AppSizes.p24),
                      // Chart
                      _buildChartSection(),
                      const SizedBox(height: AppSizes.p24),
                      // Asset Allocation
                      _buildAssetAllocation(),
                      const SizedBox(height: AppSizes.p24),
                      // Top Holdings (Using the list from summary)
                      _buildTopHoldings(summary.holdings, context),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(double value, double load) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.r24),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.totalPortfolioValue,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: AppSizes.p8),
          Text(AppFormatters.formatCurrency(value),
              style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSizes.p16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSizes.r8)),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up,
                        color: AppColors.success, size: AppSizes.iconSm),
                    const SizedBox(width: AppSizes.p4),
                    Text('+LKR ${load.toStringAsFixed(2)} (2.5%)',
                        style: GoogleFonts.inter(
                            color: AppColors.success,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.p8),
              Text(AppText.today,
                  style:
                      GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppText.performanceHistory,
                  style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _buildChartTab('30D', true),
                  _buildChartTab('6M', false),
                  _buildChartTab('1Y', false),
                ],
              )
            ],
          ),
          const SizedBox(height: AppSizes.p24),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('MAY 01',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10));
                          case 6:
                            return const Text('MAY 15',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10));
                          case 11:
                            return const Text('TODAY',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10));
                        }
                        return const Text('');
                      },
                      interval: 1,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(2, 2),
                      const FlSpot(4, 5),
                      const FlSpot(6, 3.1),
                      const FlSpot(8, 4),
                      const FlSpot(9.5, 3),
                      const FlSpot(11, 4),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.3),
                          AppColors.primary.withValues(alpha: 0.0),
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
        color: isSelected ? AppColors.border : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.r8),
      ),
      child: Text(text,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAssetAllocation() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.assetAllocation,
              style: GoogleFonts.inter(
                  color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSizes.p16),
          Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                          value: 75,
                          color: AppColors.primary,
                          radius: 15,
                          showTitle: false),
                      PieChartSectionData(
                          value: 20,
                          color: Colors.grey,
                          radius: 15,
                          showTitle: false),
                      PieChartSectionData(
                          value: 5,
                          color: Colors.white,
                          radius: 15,
                          showTitle: false),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.p24),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem(
                        color: AppColors.primary, label: 'Stocks', pct: '75%'),
                    _buildLegendItem(
                        color: Colors.grey, label: 'Cash', pct: '20%'),
                    _buildLegendItem(
                        color: Colors.white, label: 'Other', pct: '5%'),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(
      {required Color color, required String label, required String pct}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            CircleAvatar(radius: 4, backgroundColor: color),
            const SizedBox(width: AppSizes.p8),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          Text(pct,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTopHoldings(List<Holding> holdings, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppText.topHoldings,
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () => Pages.portfolio.go(context),
              child: Text(AppText.viewAll,
                  style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p12),
        ...holdings.take(5).map((h) => Container(
              margin: const EdgeInsets.only(bottom: AppSizes.p8),
              padding: const EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppSizes.r8)),
                    alignment: Alignment.center,
                    child: Text(h.ticker.split('.')[0],
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.name,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Text('${h.quantity.toInt()} Shares',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(AppFormatters.formatCurrency(h.marketPrice),
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      Text(
                          '${h.profitPercent > 0 ? '+' : ''}${h.profitPercent.toStringAsFixed(1)}%',
                          style: TextStyle(
                              color: h.profitPercent >= 0
                                  ? AppColors.success
                                  : AppColors.error,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            )),
      ],
    );
  }
}
