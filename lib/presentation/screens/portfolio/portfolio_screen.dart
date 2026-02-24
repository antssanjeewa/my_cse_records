import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/routing/pages.dart';
import '../../viewmodels/portfolio_viewmodel.dart';
import '../../widgets/widgets.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<PortfolioViewModel>(builder: (context, viewModel, child) {
        final filteredHoldings = viewModel.filteredHoldings;

        return RefreshIndicator(
          onRefresh: () => viewModel.fetchHoldings(),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: AppColors.background.withValues(alpha: 0.9),
                pinned: true,
                title: Text(
                  AppText.portfolioHoldings,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                centerTitle: true,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.only(
                        top: 120,
                        left: AppSizes.p16,
                        right: AppSizes.p16,
                        bottom: AppSizes.p16),
                    child: SummaryCard(
                      title: 'Total Equity',
                      mainValue:
                          viewModel.totalMarketValue - viewModel.totalValue,
                      leftLabel: 'Total Portfolio',
                      leftValue: viewModel.totalMarketValue,
                      rightLabel: 'Available balance',
                      rightValue: viewModel.cashBalance,
                    ),
                  ),
                ),
              ),

              // Sticky Search & Filter
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyHeaderDelegate(
                  minHeight: 130,
                  maxHeight: 130,
                  child: Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p16, vertical: AppSizes.p8),
                    child: Column(
                      children: [
                        // Search
                        TextField(
                          controller: _searchController,
                          onChanged: (value) => viewModel.setSearchQuery(value),
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Search ticker or company...',
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.textSecondary),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: AppColors.textSecondary),
                                    onPressed: () {
                                      _searchController.clear();
                                      viewModel.setSearchQuery('');
                                    },
                                  )
                                : null,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: AppSizes.p12),
                        // Filter Dropdowns
                        Row(
                          children: [
                            // Sort Dropdown
                            Expanded(
                              child: DropdownHeader(
                                label: 'Sort: ${viewModel.sortBy}',
                                icon: Icons.sort,
                                onTap: () {
                                  _showSortPicker(context, viewModel);
                                },
                              ),
                            ),
                            const SizedBox(width: AppSizes.p12),
                            // Sector Dropdown
                            Expanded(
                              child: DropdownHeader(
                                label: viewModel.sectorFilter == 'All'
                                    ? 'All Sectors'
                                    : viewModel.sectorFilter,
                                icon: Icons.category,
                                onTap: () {
                                  _showSectorPicker(context, viewModel);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Loading Indicator
              if (viewModel.isLoading && filteredHoldings.isNotEmpty)
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

              if (viewModel.isLoading && filteredHoldings.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (filteredHoldings.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 64, color: Colors.grey.withAlpha(50)),
                        const SizedBox(height: 16),
                        Text('No holdings found',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final holding = filteredHoldings[index];
                        return Opacity(
                          opacity: viewModel.isLoading ? 0.6 : 1.0,
                          child: HoldingCard(
                            holding: holding,
                            onTap: () =>
                                Pages.holdingDetails.push(context, extra: {
                              'holding': holding,
                              'totalValue': viewModel.totalMarketValue,
                            }),
                          ),
                        );
                      },
                      childCount: filteredHoldings.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Pages.addTransaction.push(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showSortPicker(BuildContext context, PortfolioViewModel viewModel) {
    final options = ['Name', 'Price', 'Quantity', 'Profit %'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.p20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.p12),
            ...options.map((opt) => ListTile(
                  title: Text(
                    opt,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: viewModel.sortBy == opt
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    viewModel.setSortBy(opt);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showSectorPicker(BuildContext context, PortfolioViewModel viewModel) {
    final sectors = viewModel.availableSectors;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.p20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter by Sector',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.p12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: sectors.map((sec) {
                  final isAll = sec == 'All';
                  final icon = isAll ? Icons.list : getSectorIcon(sec);
                  return ListTile(
                    leading:
                        Icon(icon, color: AppColors.textSecondary, size: 20),
                    title: Text(
                      isAll ? 'All Sectors' : sec,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: viewModel.sectorFilter == sec
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      viewModel.setSectorFilter(sec);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
