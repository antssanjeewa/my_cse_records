import 'package:flutter/material.dart';

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
                  style: Theme.of(context).textTheme.titleLarge),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r24)),
      ),
      builder: (context) {
        return _CompanyFilterSheet(viewModel: viewModel);
      },
    );
  }
}

class _CompanyFilterSheet extends StatefulWidget {
  final TransactionHistoryViewModel viewModel;
  const _CompanyFilterSheet({required this.viewModel});

  @override
  State<_CompanyFilterSheet> createState() => _CompanyFilterSheetState();
}

class _CompanyFilterSheetState extends State<_CompanyFilterSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final stocks = widget.viewModel.uniqueStocks.where((s) {
      final query = _searchQuery.toLowerCase();
      return s.ticker.toLowerCase().contains(query) ||
          s.name.toLowerCase().contains(query);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.fromLTRB(
          AppSizes.p20, AppSizes.p20, AppSizes.p20, 0),
      child: Column(
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.p20),

          Text('Select Company', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSizes.p20),

          // Search Field
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search ticker or company name...',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: AppSizes.p12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: AppSizes.p32),
              itemCount: stocks.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = widget.viewModel.tickerFilter == null;
                  return _buildCompanyItem(
                    title: 'All Companies',
                    subtitle: 'Show all transactions',
                    isSelected: isSelected,
                    onTap: () {
                      widget.viewModel.setStockFilter(null, null);
                      Navigator.pop(context);
                    },
                  );
                }

                final stock = stocks[index - 1];
                final isSelected =
                    widget.viewModel.tickerFilter == stock.ticker;

                return _buildCompanyItem(
                  title: stock.ticker,
                  subtitle: stock.name,
                  trailing: stock.sector,
                  isSelected: isSelected,
                  onTap: () {
                    widget.viewModel.setStockFilter(stock.id, stock.ticker);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyItem({
    required String title,
    required String subtitle,
    String? trailing,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
