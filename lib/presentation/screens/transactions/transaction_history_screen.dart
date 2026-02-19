import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/routing/pages.dart';
import '../../viewmodels/transaction_history_viewmodel.dart';
import 'widgets/transaction_filter_bar.dart';
import 'widgets/transaction_history_item.dart';

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
                    style: Theme.of(context).textTheme.titleLarge),
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
                  child: TransactionFilterBar(
                    viewModel: viewModel,
                    onSelectDateRange: () =>
                        _selectDateRange(context, viewModel),
                  ),
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
                          child: TransactionHistoryItem(transaction: t),
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

  Future<void> _selectDateRange(
      BuildContext context, TransactionHistoryViewModel viewModel) async {
    final firstDate = DateTime(2020);
    final lastDate = DateTime.now();
    DateTimeRange? initialRange;
    if (viewModel.startDate != null && viewModel.endDate != null) {
      final start = viewModel.startDate!;
      final end = viewModel.endDate!;
      final safeStart = start.isBefore(firstDate) ? firstDate : start;
      final safeEnd = end.isAfter(lastDate) ? lastDate : end;
      if (!safeStart.isAfter(safeEnd)) {
        initialRange = DateTimeRange(start: safeStart, end: safeEnd);
      }
    }
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: initialRange,
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
}
