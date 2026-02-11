import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/entities/transaction.dart';

enum ChartPeriod { week, month, year }

class HomeTransactionChart extends StatefulWidget {
  final List<Transaction> transactions;

  const HomeTransactionChart({
    super.key,
    required this.transactions,
  });

  @override
  State<HomeTransactionChart> createState() => _HomeTransactionChartState();
}

class _HomeTransactionChartState extends State<HomeTransactionChart> {
  ChartPeriod selectedPeriod = ChartPeriod.week;

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
                    tooltipBorderRadius: BorderRadius.circular(8),
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
        meta: meta,
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
        meta: meta,
        space: 10,
        child: Text(text,
            style: const TextStyle(
                color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
      );
    } else {
      final now = DateTime.now();
      final year = now.year - (2 - value.toInt());
      return SideTitleWidget(
        meta: meta,
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
