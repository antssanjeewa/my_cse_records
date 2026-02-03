import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/transaction.dart';
import '../viewmodels/transaction_history_viewmodel.dart';
import '../../core/routing/pages.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/formatters.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<TransactionHistoryViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final filteredTransactions = viewModel.filteredTransactions;

          return CustomScrollView(
            slivers: [
              // Sticky Top Bar
              SliverAppBar(
                backgroundColor: AppColors.background.withValues(alpha: 0.9),
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: AppColors.textPrimary, size: AppSizes.iconMd),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(AppText.transactionHistory,
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon:
                        const Icon(Icons.search, color: AppColors.textPrimary),
                    onPressed: () {},
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    children: [
                      // Segmented Control
                      Container(
                        height: 44,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(AppSizes.r12),
                        ),
                        child: Row(
                          children: [
                            _buildSegment(context, viewModel, 'All'),
                            _buildSegment(context, viewModel, 'Buy'),
                            _buildSegment(context, viewModel, 'Sell'),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.p16),
                      // Company Filter
                      GestureDetector(
                        onTap: () => _showCompanyFilter(context, viewModel),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p16, vertical: AppSizes.p12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSizes.r12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.business,
                                      color: AppColors.primary,
                                      size: AppSizes.iconMd),
                                  const SizedBox(width: AppSizes.p12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('COMPANY',
                                          style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0)),
                                      const SizedBox(height: 2),
                                      Text(
                                          viewModel.tickerFilter ??
                                              'All Companies',
                                          style: GoogleFonts.inter(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                              if (viewModel.tickerFilter != null)
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      size: 16, color: Colors.grey),
                                  onPressed: () =>
                                      viewModel.setTickerFilter(null),
                                )
                              else
                                const Icon(Icons.expand_more,
                                    color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.p12),
                      // Date Range
                      GestureDetector(
                        onTap: () => _selectDateRange(context, viewModel),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p16, vertical: AppSizes.p12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSizes.r12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: AppColors.primary,
                                      size: AppSizes.iconMd),
                                  const SizedBox(width: AppSizes.p12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('DATE RANGE',
                                          style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0)),
                                      const SizedBox(height: 2),
                                      Text(
                                          _formatDateRange(viewModel.startDate,
                                              viewModel.endDate),
                                          style: GoogleFonts.inter(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                              if (viewModel.startDate != null)
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      size: 16, color: Colors.grey),
                                  onPressed: () =>
                                      viewModel.setDateFilter(null, null),
                                )
                              else
                                const Icon(Icons.expand_more,
                                    color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (filteredTransactions.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text('No transactions found',
                        style: TextStyle(color: Colors.white54)),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final t = filteredTransactions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p16, vertical: 0),
                        child: _buildTransactionItem(t),
                      );
                    },
                    childCount: filteredTransactions.length,
                  ),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p24),
                  child: Column(
                    children: [
                      const Icon(Icons.history,
                          color: Colors.white54, size: AppSizes.iconXl),
                      const SizedBox(height: AppSizes.p8),
                      Text(
                          'Showing ${filteredTransactions.length} transactions',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Pages.addTransaction.push(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSegment(BuildContext context,
      TransactionHistoryViewModel viewModel, String label) {
    final isSelected = viewModel.typeFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => viewModel.setTypeFilter(label),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.r8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2)
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              )),
        ),
      ),
    );
  }

  Future<void> _selectDateRange(
      BuildContext context, TransactionHistoryViewModel viewModel) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: viewModel.startDate != null && viewModel.endDate != null
          ? DateTimeRange(start: viewModel.startDate!, end: viewModel.endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      viewModel.setDateFilter(picked.start, picked.end);
    }
  }

  void _showCompanyFilter(
      BuildContext context, TransactionHistoryViewModel viewModel) {
    final tickers = viewModel.availableTickers;

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
                  itemCount: tickers.length + 1,
                  itemBuilder: (context, index) {
                    final item = index == 0 ? null : tickers[index - 1];
                    return ListTile(
                      title: Text(item ?? 'All Companies',
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        viewModel.setTickerFilter(item);
                        Navigator.pop(context);
                      },
                      trailing: viewModel.tickerFilter == item
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

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 'All Time';
    return '${DateFormat('MMM dd').format(start)} - ${DateFormat('MMM dd, yyyy').format(end)}';
  }

  Widget _buildTransactionItem(Transaction t) {
    final isBuy = t.type == TransactionType.buy;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isBuy ? AppColors.primary : Colors.grey[700],
                    shape: BoxShape.circle,
                    boxShadow: isBuy
                        ? [
                            const BoxShadow(
                                color: AppColors.primary,
                                blurRadius: 10,
                                spreadRadius: -2)
                          ]
                        : [],
                  ),
                  child: Icon(isBuy ? Icons.shopping_cart : Icons.sell,
                      color: Colors.white, size: AppSizes.iconMd),
                ),
                Expanded(child: Container(width: 2, color: AppColors.border)),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.p8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isBuy
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSizes.r4),
                            ),
                            child: Text(t.typeString.toUpperCase(),
                                style: TextStyle(
                                    color: isBuy
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: AppSizes.p4),
                          Text(t.name,
                              style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(t.ticker,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(AppFormatters.dateDetailed.format(t.date),
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p12),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: AppSizes.p12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('QUANTITY',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(
                              '${AppFormatters.formatNumber(t.quantity)} Shares',
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PRICE',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(AppFormatters.formatCurrency(t.price),
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p12),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: AppSizes.p12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Value',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      Text(AppFormatters.formatCurrency(t.totalValue),
                          style: TextStyle(
                              color:
                                  isBuy ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
