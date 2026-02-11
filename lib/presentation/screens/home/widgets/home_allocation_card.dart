import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class ChartSectionData {
  final double value;
  final Color color;
  final String label;

  ChartSectionData({
    required this.value,
    required this.color,
    required this.label,
  });
}

class HomeAllocationCard extends StatefulWidget {
  final String title;
  final List<ChartSectionData> sections;

  const HomeAllocationCard({
    super.key,
    required this.title,
    required this.sections,
  });

  @override
  State<HomeAllocationCard> createState() => _HomeAllocationCardState();
}

class _HomeAllocationCardState extends State<HomeAllocationCard> {
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
          SizedBox(
            height: 180,
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
                            final radius = isTouched ? 50.0 : 40.0;

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
                          widget.title,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 14),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
