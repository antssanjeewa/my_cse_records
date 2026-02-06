import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          final filteredTransactions = viewModel.filteredTransactions;

          return CustomScrollView(
            slivers: [
              // Sticky Top Bar
              SliverAppBar(
                backgroundColor: AppColors.background.withValues(alpha: 0.9),
                pinned: true,
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
                  child: Column(children: [
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
                          _buildTimeSegment(context, viewModel, 'All'),
                          _buildTimeSegment(context, viewModel, 'Month'),
                          _buildTimeSegment(context, viewModel, 'Custom'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p16),
                    Row(
                      children: [
                        // Company Filter
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showCompanyFilter(context, viewModel),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.p16,
                                  vertical: AppSizes.p12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppSizes.r12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('COMPANY',
                                      style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0)),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.business,
                                          color: AppColors.primary,
                                          size: AppSizes.iconMd),
                                      const SizedBox(width: AppSizes.p8),
                                      Expanded(
                                        child: Text(
                                            viewModel.tickerFilter ?? 'All',
                                            style: GoogleFonts.inter(
                                                color: AppColors.textPrimary,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      if (viewModel.tickerFilter != null)
                                        GestureDetector(
                                          onTap: () => viewModel.setStockFilter(
                                              null, null),
                                          child: const Icon(Icons.close,
                                              size: 14, color: Colors.grey),
                                        )
                                      else
                                        const Icon(Icons.expand_more,
                                            size: 14, color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.p12),
                        // Type Filter
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showTypeFilter(context, viewModel),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.p16,
                                  vertical: AppSizes.p12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppSizes.r12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('TYPE',
                                      style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0)),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.filter_list,
                                          color: AppColors.primary,
                                          size: AppSizes.iconMd),
                                      const SizedBox(width: AppSizes.p8),
                                      Expanded(
                                        child: Text(viewModel.typeFilter,
                                            style: GoogleFonts.inter(
                                                color: AppColors.textPrimary,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      if (viewModel.typeFilter != 'All')
                                        GestureDetector(
                                          onTap: () =>
                                              viewModel.setTypeFilter('All'),
                                          child: const Icon(Icons.close,
                                              size: 14, color: Colors.grey),
                                        )
                                      else
                                        const Icon(Icons.expand_more,
                                            size: 14, color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),

              // Loading Indicator
              if (viewModel.isLoading && filteredTransactions.isNotEmpty)
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: AppColors.primary,
                    minHeight: 2,
                  ),
                ),

              if (viewModel.isLoading && filteredTransactions.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (filteredTransactions.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.compare_arrows,
                            size: 64, color: Colors.grey.withAlpha(50)),
                        const SizedBox(height: 16),
                        const Text('No Transactions found',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final t = filteredTransactions[index];
                      return Opacity(
                        opacity: viewModel.isLoading ? 0.6 : 1.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p16, vertical: 0),
                          child: _buildTransactionItem(t),
                        ),
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
                      if (viewModel.hasMore) ...[
                        const SizedBox(height: AppSizes.p16),
                        TextButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () => viewModel.loadMore(),
                          child: viewModel.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: AppColors.primary))
                              : const Text('Load More',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ],
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

  Widget _buildTimeSegment(BuildContext context,
      TransactionHistoryViewModel viewModel, String label) {
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

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (label == 'All') {
            viewModel.setDateFilter(null, null);
          } else if (label == 'Month') {
            final start = DateTime.now().subtract(const Duration(days: 30));
            viewModel.setDateFilter(start, DateTime.now());
          } else if (label == 'Custom') {
            // Open the date range picker for a custom range
            _selectDateRange(context, viewModel);
          }
        },
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

  void _showTypeFilter(
      BuildContext context, TransactionHistoryViewModel viewModel) {
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

  Widget _buildTransactionItem(Transaction t) {
    final isBuy = t.type == TransactionType.buy;
    final isDividend = t.type == TransactionType.dividend;

    Color color;
    if (isDividend) {
      color = AppColors.info;
    } else if (isBuy) {
      color = AppColors.success;
    } else {
      color = AppColors.error;
    }

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
                    color: color.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                      isDividend
                          ? Icons.attach_money
                          : isBuy
                              ? Icons.shopping_cart
                              : Icons.sell,
                      color: Colors.white,
                      size: AppSizes.iconMd),
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
                  border: Border.all(color: color.withAlpha(100))),
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
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSizes.r4),
                            ),
                            child: Text(t.typeString.toUpperCase(),
                                style: TextStyle(
                                    color: color,
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
                  Divider(color: color.withAlpha(100), height: 1),
                  const SizedBox(height: AppSizes.p12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('QUANTITY | UNIT PRICE',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                children: [
                                  TextSpan(
                                      text: AppFormatters.formatNumber(
                                          t.quantity)),
                                  const TextSpan(
                                      text: ' @ ',
                                      style: TextStyle(
                                          color: AppColors.textPrimary)),
                                  TextSpan(text: t.unit_price.toString()),
                                ]),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('TOTAL VALUE',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(AppFormatters.formatCurrency(t.total_price),
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
