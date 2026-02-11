import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/routing/pages.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../../domain/entities/transaction.dart';
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
          final summary = viewModel.summary;
          final isInitialLoad = viewModel.isLoading && summary == null;

          return RefreshIndicator(
            onRefresh: () => viewModel.fetchSummary(),
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: AppColors.background.withValues(alpha: 0.9),
                  floating: true,
                  leading: Container(
                    margin: const EdgeInsets.only(left: AppSizes.p20),
                    child: Hero(
                      tag: 'app_logo_hero',
                      child: Image.asset(
                        AppAssets.logo,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
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
                      Row(
                        children: [
                          Text(
                            viewModel.isMarketOpen
                                ? 'MARKET OPEN'
                                : 'MARKET CLOSED',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: viewModel.isMarketOpen
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: AppSizes.p8),
                          Text(
                            '• ${viewModel.currentTime}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.5),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      )
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

                // Loading Indicator
                if (viewModel.isLoading && summary != null)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: AppColors.primary,
                        minHeight: 2,
                      ),
                    ),
                  ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    child: isInitialLoad
                        ? Column(
                            children: [
                              _buildLoadingSkeleton(),
                            ],
                          )
                        : summary == null
                            ? const Center(
                                child: Text('Unable to load summary',
                                    style: TextStyle(
                                        color: AppColors.textSecondary)),
                              )
                            : Opacity(
                                opacity: viewModel.isLoading ? 0.6 : 1.0,
                                child: Column(
                                  children: [
                                    _buildHeroCard(summary),
                                    const SizedBox(height: AppSizes.p24),
                                    _buildTransactionBarChart(
                                        viewModel.recentTransactions),
                                    const SizedBox(height: AppSizes.p24),
                                    _buildAllocationRow(summary),
                                    const SizedBox(height: AppSizes.p24),
                                    _buildRecentTransactions(
                                        viewModel.recentTransactions, context),
                                  ],
                                ),
                              ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(PortfolioSummary summary) {
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
          Text('Net Worth',
              style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(AppFormatters.formatCurrency(summary.netWorth),
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSizes.p12),
          // Breakdown Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Portfolio value',
                        style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(AppFormatters.formatCurrency(summary.totalValue),
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              const SizedBox(width: AppSizes.p16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available balance',
                        style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(AppFormatters.formatCurrency(summary.cashBalance),
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(
      List<Transaction> transactions, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Activity',
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            if (transactions.isNotEmpty)
              GestureDetector(
                onTap: () => Pages.transactions.go(context),
                child: Text(AppText.viewAll,
                    style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.p12),
        if (transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSizes.p20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.r16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text('No recent transactions',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ),
          )
        else
          ...transactions.map((t) {
            final summary = context.read<HomeViewModel>().summary;
            if (summary == null) return const SizedBox();

            // Find the parent holding for this transaction to allow navigation
            final parentHolding =
                summary.holdings.firstWhere((h) => h.stockId == t.stockId);

            return GestureDetector(
              onTap: () {
                if (parentHolding.id.isNotEmpty) {
                  Pages.holdingDetails.push(context, extra: {
                    'holding': parentHolding,
                    'totalValue': summary.totalValue + summary.totalProfit,
                  });
                }
              },
              child: Container(
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
                        color: (t.type == TransactionType.buy
                                ? AppColors.primary
                                : t.type == TransactionType.sell
                                    ? AppColors.error
                                    : AppColors.success)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                      ),
                      child: Icon(
                        t.type == TransactionType.buy
                            ? Icons.add_chart
                            : t.type == TransactionType.sell
                                ? Icons.show_chart
                                : Icons.account_balance_wallet,
                        color: t.type == TransactionType.buy
                            ? AppColors.primary
                            : t.type == TransactionType.sell
                                ? AppColors.error
                                : AppColors.success,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.ticker.split('.')[0],
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          Text(
                              '${t.typeString} • ${AppFormatters.dateOnly.format(t.date)}',
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(t.type == TransactionType.sell || t.type == TransactionType.dividend) ? '+' : '-'} ${AppFormatters.formatCurrency(t.total_price)}',
                          style: TextStyle(
                            color: (t.type == TransactionType.sell ||
                                    t.type == TransactionType.dividend)
                                ? AppColors.success
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${t.qty.toInt()} Shares',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildTransactionBarChart(List<Transaction> transactions) {
    return _TransactionActivityChart(transactions: transactions);
  }

  Widget _buildAllocationRow(PortfolioSummary summary) {
    return Row(
      children: [
        Expanded(
          child: _AllocationCard(
            title: 'Assets',
            sections: [
              _ChartSectionData(
                value: summary.totalValue,
                color: AppColors.primary,
                label: 'Stocks',
              ),
              _ChartSectionData(
                value: summary.cashBalance,
                color: Colors.orange,
                label: 'Cash',
              ),
              _ChartSectionData(
                value: summary.totalDividends,
                color: Colors.green,
                label: 'Div',
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.p12),
        Expanded(
          child: _AllocationCard(
            title: 'Stocks',
            sections: _getStockSections(summary.holdings),
          ),
        ),
      ],
    );
  }

  List<_ChartSectionData> _getStockSections(List<Holding> holdings) {
    if (holdings.isEmpty) return [];
    final sorted = List<Holding>.from(holdings)
      ..sort((a, b) => b.totalPrice.compareTo(a.totalPrice));

    final top4 = sorted.take(4).toList();
    final otherVal = sorted.length > 4
        ? sorted.skip(4).fold(0.0, (sum, h) => sum + h.totalPrice)
        : 0.0;

    final palette = [
      AppColors.primary,
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
    ];

    final List<_ChartSectionData> sections = [];
    for (int i = 0; i < top4.length; i++) {
      sections.add(_ChartSectionData(
        value: top4[i].totalPrice,
        color: palette[i],
        label: top4[i].ticker.split('.')[0],
      ));
    }

    if (otherVal > 0) {
      sections.add(_ChartSectionData(
        value: otherVal,
        color: Colors.grey.withValues(alpha: 0.3),
        label: 'Other',
      ));
    }

    return sections;
  }
}

class _ChartSectionData {
  final double value;
  final Color color;
  final String label;

  _ChartSectionData({
    required this.value,
    required this.color,
    required this.label,
  });
}

class _AllocationCard extends StatefulWidget {
  final String title;
  final List<_ChartSectionData> sections;

  const _AllocationCard({required this.title, required this.sections});

  @override
  State<_AllocationCard> createState() => _AllocationCardState();
}

class _AllocationCardState extends State<_AllocationCard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.sections.fold(0.0, (sum, s) => sum + s.value);

    return Container(
      padding: const EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(widget.title,
              style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSizes.p8),
          SizedBox(
            height: 140,
            child: widget.sections.isEmpty || total == 0
                ? Center(
                    child: Text('Empty',
                        style: TextStyle(
                            color: Colors.grey.withValues(alpha: 0.5),
                            fontSize: 10)))
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          sections:
                              widget.sections.asMap().entries.map((entry) {
                            final isTouched = entry.key == touchedIndex;
                            final radius = isTouched ? 22.0 : 18.0;

                            return PieChartSectionData(
                              value: entry.value.value,
                              color: entry.value.color,
                              radius: radius,
                              showTitle: false,
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 42,
                        ),
                      ),
                      if (touchedIndex != -1)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.sections[touchedIndex].label,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${((widget.sections[touchedIndex].value / total) * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 9),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Tap',
                          style: TextStyle(
                              color: Colors.grey.withValues(alpha: 0.3),
                              fontSize: 9),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLoadingSkeleton() {
  return Column(
    children: [
      // Hero Card Skeleton
      Container(
        padding: const EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            Container(
              width: 400,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppSizes.p16),
            Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSizes.r8),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSizes.p24),
      const SizedBox(height: AppSizes.p24),
      // Allocation Row Skeleton
      Row(
        children: [
          Expanded(child: _buildChartSkeleton()),
          const SizedBox(width: AppSizes.p16),
          Expanded(child: _buildChartSkeleton()),
        ],
      ),
      const SizedBox(height: AppSizes.p24),
      // Transactions Skeleton
      Container(
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
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p16),
            ...List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: AppSizes.p8),
                padding: const EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                      ),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 60,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildChartSkeleton() {
  return Container(
    padding: const EdgeInsets.all(AppSizes.p12),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.r24),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        Container(
          width: 50,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: AppSizes.p12),
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.surfaceLight,
            shape: BoxShape.circle,
          ),
        ),
      ],
    ),
  );
}

class _TransactionActivityChart extends StatefulWidget {
  final List<Transaction> transactions;

  const _TransactionActivityChart({required this.transactions});

  @override
  State<_TransactionActivityChart> createState() =>
      _TransactionActivityChartState();
}

enum ChartPeriod { week, month, year }

class _TransactionActivityChartState extends State<_TransactionActivityChart> {
  ChartPeriod selectedPeriod = ChartPeriod.month;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transaction Activity',
                  style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildToggleItem(
                        'Week', selectedPeriod == ChartPeriod.week),
                    _buildToggleItem(
                        'Month', selectedPeriod == ChartPeriod.month),
                    _buildToggleItem(
                        'Year', selectedPeriod == ChartPeriod.year),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p24),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rodIndex == 0 ? "Buy" : "Sell"}\n${AppFormatters.formatCurrency(rod.toY)}',
                        GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: _getBottomTitles,
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: _getBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'Week') {
            selectedPeriod = ChartPeriod.week;
          } else if (label == 'Month') {
            selectedPeriod = ChartPeriod.month;
          } else {
            selectedPeriod = ChartPeriod.year;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  double _getMaxY() {
    double max = 0;
    final groups = _getBarGroups();
    for (var group in groups) {
      for (var rod in group.barRods) {
        if (rod.toY > max) max = rod.toY;
      }
    }
    return max == 0 ? 100 : max * 1.2;
  }

  List<BarChartGroupData> _getBarGroups() {
    if (widget.transactions.isEmpty) return [];

    if (selectedPeriod == ChartPeriod.week) {
      // Group by last 7 days
      final now = DateTime.now();
      return List.generate(7, (i) {
        final date = DateTime(now.year, now.month, now.day - (6 - i));
        double buyAmount = 0;
        double sellAmount = 0;

        for (var t in widget.transactions) {
          if (t.date.year == date.year &&
              t.date.month == date.month &&
              t.date.day == date.day) {
            if (t.type == TransactionType.buy) {
              buyAmount += t.total_price;
            } else if (t.type == TransactionType.sell) {
              sellAmount += t.total_price;
            }
          }
        }

        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: buyAmount,
              color: AppColors.primary,
              width: 8,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            BarChartRodData(
              toY: sellAmount,
              color: AppColors.error,
              width: 8,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        );
      });
    } else if (selectedPeriod == ChartPeriod.month) {
      // Group by month for the last 6 months
      final now = DateTime.now();
      return List.generate(6, (i) {
        final monthDate = DateTime(now.year, now.month - (5 - i), 1);
        double buyAmount = 0;
        double sellAmount = 0;

        for (var t in widget.transactions) {
          if (t.date.year == monthDate.year &&
              t.date.month == monthDate.month) {
            if (t.type == TransactionType.buy) {
              buyAmount += t.total_price;
            } else if (t.type == TransactionType.sell) {
              sellAmount += t.total_price;
            }
          }
        }

        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: buyAmount,
              color: AppColors.primary,
              width: 8,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            BarChartRodData(
              toY: sellAmount,
              color: AppColors.error,
              width: 8,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        );
      });
    } else {
      // Group by last 3 years
      final now = DateTime.now();
      return List.generate(3, (i) {
        final year = now.year - (2 - i);
        double buyAmount = 0;
        double sellAmount = 0;

        for (var t in widget.transactions) {
          if (t.date.year == year) {
            if (t.type == TransactionType.buy) {
              buyAmount += t.total_price;
            } else if (t.type == TransactionType.sell) {
              sellAmount += t.total_price;
            }
          }
        }

        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: buyAmount,
              color: AppColors.primary,
              width: 12,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            BarChartRodData(
              toY: sellAmount,
              color: AppColors.error,
              width: 12,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        );
      });
    }
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    if (selectedPeriod == ChartPeriod.week) {
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day - (6 - value.toInt()));
      final text = _getWeekdayName(date.weekday);
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(text,
            style: const TextStyle(
                color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
      );
    } else if (selectedPeriod == ChartPeriod.month) {
      final now = DateTime.now();
      final monthDate = DateTime(now.year, now.month - (5 - value.toInt()), 1);
      final text = _getMonthName(monthDate.month);
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(text,
            style: const TextStyle(
                color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
      );
    } else {
      final now = DateTime.now();
      final year = now.year - (2 - value.toInt());
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text('$year',
            style: const TextStyle(
                color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
      );
    }
  }

  String _getWeekdayName(int weekday) {
    const names = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return names[weekday - 1];
  }

  String _getMonthName(int month) {
    const names = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return names[month - 1];
  }
}
