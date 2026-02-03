import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/holding.dart';
import '../viewmodels/portfolio_viewmodel.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/routing/pages.dart';

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
        if (viewModel.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }

        return CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: AppColors.background.withValues(alpha: 0.9),
              pinned: true,
              title: Text(AppText.portfolioHoldings,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textPrimary)),
              centerTitle: true,
              actions: [
                IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {}),
              ],
              expandedHeight: 220,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(
                      top: 120,
                      left: AppSizes.p16,
                      right: AppSizes.p16,
                      bottom: AppSizes.p16),
                  child: _buildSummaryCard(viewModel),
                ),
              ),
            ),

            // Sticky Search & Filter
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
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
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          hintText: 'Search ticker or company...',
                          hintStyle:
                              const TextStyle(color: AppColors.textSecondary),
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                              borderSide:
                                  const BorderSide(color: AppColors.border)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                              borderSide:
                                  const BorderSide(color: AppColors.border)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                              borderSide:
                                  const BorderSide(color: AppColors.primary)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(height: AppSizes.p12),
                      // Filter Dropdowns
                      Row(
                        children: [
                          // Sort Dropdown
                          Expanded(
                            child: _buildDropdownHeader(
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
                            child: _buildDropdownHeader(
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

            // List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final holding = viewModel.filteredHoldings[index];
                    return _buildHoldingCard(holding);
                  },
                  childCount: viewModel.filteredHoldings.length,
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Pages.addTransaction.push(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(PortfolioViewModel vm) {
    double totalValue = vm.holdings.fold(0, (sum, h) => sum + h.value);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.r20),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total Equity',
              style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: AppSizes.p4),
          Text(AppFormatters.formatCurrency(totalValue),
              style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSizes.p12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSizes.r20)),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up,
                        color: Colors.white, size: AppSizes.iconSm),
                    SizedBox(width: AppSizes.p4),
                    Text('+2.4% Today',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.p12),
              Text('Market: Open',
                  style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDropdownHeader({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.expand_more, size: 16, color: Colors.grey),
          ],
        ),
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
            const Text('Sort By',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.p12),
            ...options.map((opt) => ListTile(
                  title: Text(opt,
                      style: const TextStyle(color: AppColors.textPrimary)),
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
            const Text('Filter by Sector',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.p12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: sectors
                    .map((sec) => ListTile(
                          title: Text(sec,
                              style: const TextStyle(
                                  color: AppColors.textPrimary)),
                          trailing: viewModel.sectorFilter == sec
                              ? const Icon(Icons.check,
                                  color: AppColors.primary)
                              : null,
                          onTap: () {
                            viewModel.setSectorFilter(sec);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingCard(Holding h) {
    final profit = h.profit;
    final profitPct = h.profitPercent;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.p16),
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h.sector,
                      style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0)),
                  Text(h.ticker,
                      style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(h.name,
                      style: GoogleFonts.inter(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppSizes.r12)),
                child: const Icon(Icons.business,
                    color: Colors.white54, size: AppSizes.iconMd),
              )
            ],
          ),
          const SizedBox(height: AppSizes.p12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSizes.p12),
          // Middle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QUANTITY | AVG COST',
                      style: TextStyle(
                          color: Colors.grey,
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
                              text: AppFormatters.formatNumber(h.quantity)),
                          const TextSpan(
                              text: ' @ ',
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(text: h.avgPrice.toStringAsFixed(2)),
                        ]),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('MARKET PRICE',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(AppFormatters.formatCurrency(h.marketPrice),
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              )
            ],
          ),
          const SizedBox(height: AppSizes.p12),
          // Bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('UNREALIZED P/L',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                      (profit > 0 ? '+' : '') +
                          AppFormatters.formatCurrency(profit),
                      style: TextStyle(
                          color:
                              profit > 0 ? AppColors.success : AppColors.error,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: (profit > 0 ? AppColors.successBg : AppColors.errorBg)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                ),
                child: Row(
                  children: [
                    Icon(profit > 0 ? Icons.trending_up : Icons.trending_down,
                        color: profit > 0 ? AppColors.success : AppColors.error,
                        size: 16),
                    const SizedBox(width: AppSizes.p4),
                    Text(
                        '${profitPct > 0 ? '+' : ''}${profitPct.toStringAsFixed(2)}%',
                        style: TextStyle(
                            color: profit > 0
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate(
      {required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;
  @override
  double get maxExtent => maxHeight;
  @override
  double get minExtent => minHeight;
  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) => true;
}
