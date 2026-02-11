import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/constants.dart';
import '../../../viewmodels/transaction_history_viewmodel.dart';
import '../../../widgets/widgets.dart'; // For DropdownHeader
import 'time_filter_segment.dart';

class TransactionFilterBar extends StatelessWidget {
  final TransactionHistoryViewModel viewModel;
  final VoidCallback onSelectDateRange;

  const TransactionFilterBar({
    super.key,
    required this.viewModel,
    required this.onSelectDateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Time Segment
        Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppSizes.r12),
          ),
          child: Row(
            children: [
              _buildSegment(context, 'All'),
              _buildSegment(context, 'Month'),
              _buildSegment(context, 'Custom'),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.p16),
        Row(
          children: [
            // Company Filter
            Expanded(
              child: DropdownHeader(
                label: viewModel.tickerFilter ?? 'All Companies',
                icon: Icons.business,
                onTap: () => _showCompanyFilter(context),
              ),
            ),
            const SizedBox(width: AppSizes.p12),
            // Type Filter
            Expanded(
              child: DropdownHeader(
                label: viewModel.typeFilter,
                icon: Icons.filter_list,
                onTap: () => _showTypeFilter(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSegment(BuildContext context, String label) {
    bool isSelected = false;
    if (label == 'All') {
      isSelected = viewModel.startDate == null && viewModel.endDate == null;
    } else if (label == 'Month') {
      if (viewModel.startDate != null && viewModel.endDate != null) {
        final days = viewModel.endDate!.difference(viewModel.startDate!).inDays;
        isSelected = days <= 31;
      }
    } else if (label == 'Custom') {
      if (viewModel.startDate != null && viewModel.endDate != null) {
        final days = viewModel.endDate!.difference(viewModel.startDate!).inDays;
        isSelected = days > 31;
      }
    }

    return TimeFilterSegment(
      label: label,
      isSelected: isSelected,
      onTap: () {
        if (label == 'All') {
          viewModel.setDateFilter(null, null);
        } else if (label == 'Month') {
          final start = DateTime.now().subtract(const Duration(days: 30));
          viewModel.setDateFilter(start, DateTime.now());
        } else if (label == 'Custom') {
          onSelectDateRange();
        }
      },
    );
  }

  void _showTypeFilter(BuildContext context) {
    final options = ['All', 'Buy', 'Sell', 'Dividend'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter by Type',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: AppSizes.p16),
              ...options.map((opt) => ListTile(
                    title:
                        Text(opt, style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      viewModel.setTypeFilter(opt);
                      Navigator.pop(context);
                    },
                    trailing: viewModel.typeFilter == opt
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                  ))
            ],
          ),
        );
      },
    );
  }

  void _showCompanyFilter(BuildContext context) {
    final uniqueStocks = viewModel.uniqueStocks;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter by Company',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: AppSizes.p16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: uniqueStocks.length + 1,
                  itemBuilder: (context, index) {
                    final item = index == 0 ? null : uniqueStocks[index - 1];
                    return ListTile(
                      title: Text(item?['ticker'] ?? 'All Companies',
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        viewModel.setStockFilter(item?['id'], item?['ticker']);
                        Navigator.pop(context);
                      },
                      trailing: viewModel.tickerFilter == item?['ticker']
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
