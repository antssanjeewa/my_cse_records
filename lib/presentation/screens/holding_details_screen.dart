import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/holding.dart';
import '../../domain/entities/transaction.dart';
import '../viewmodels/holding_details_viewmodel.dart';

class HoldingDetailsScreen extends StatelessWidget {
  const HoldingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HoldingDetailsViewModel>(
      builder: (context, viewModel, child) {
        final h = viewModel.holding;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Modern Sticky Header
                  SliverAppBar(
                    backgroundColor:
                        AppColors.background.withValues(alpha: 0.8),
                    pinned: true,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.ticker,
                            style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(h.name,
                            style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    centerTitle: false,
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.p16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Current Portfolio Value Section
                          _buildValueSection(viewModel),
                          const SizedBox(height: AppSizes.p20),

                          // 2. Position Summary Card
                          _buildPositionSummary(h),
                          const SizedBox(height: AppSizes.p20),

                          // 3. Recent Activity Section
                          _buildActivitySection(viewModel),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Sticky Navigation
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: _buildBottomNav(context),
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildValueSection(HoldingDetailsViewModel vm) {
    final h = vm.holding;
    final marketPrice = h.stock?.lastPrice ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CURRENT PORTFOLIO VALUE',
                      style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(AppFormatters.formatCurrency(vm.marketValue),
                      style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                ),
                child: Text(
                  '${vm.concentration.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'MARKET PRICE: ${AppFormatters.formatCurrency(marketPrice)} (+2.04%)',
                style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionSummary(Holding h) {
    final isPositive = h.profit >= 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('POSITION SUMMARY',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2)),
                GridView.count(
                  padding: const EdgeInsets.only(top: AppSizes.p20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  children: [
                    _buildSummaryItem(
                        'Total Shares', AppFormatters.formatNumber(h.quantity)),
                    _buildSummaryItem('Average Cost',
                        AppFormatters.formatCurrency(h.avgPrice)),
                    _buildSummaryItem('Invested Value',
                        AppFormatters.formatCurrency(h.totalPrice)),
                    _buildSummaryItem(
                        'Current P/L',
                        (isPositive ? '+' : '') +
                            AppFormatters.formatCurrency(h.profit),
                        color:
                            isPositive ? AppColors.success : AppColors.error),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.normal)),
        const SizedBox(height: 2),
        Text(value,
            style: GoogleFonts.inter(
                color: color ?? AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActivitySection(HoldingDetailsViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('RECENT ACTIVITY',
                  style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2)),
              Text('VIEW ALL',
                  style: GoogleFonts.inter(
                      color: AppColors.info,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Segmented Control
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildFilterTab(vm, TransactionFilter.all, 'ALL'),
              _buildFilterTab(vm, TransactionFilter.buy, 'BUY'),
              _buildFilterTab(vm, TransactionFilter.sell, 'SELL'),
              _buildFilterTab(vm, TransactionFilter.dividend, 'DIV'),
            ],
          ),
        ),

        if (vm.isLoading)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(AppSizes.p20),
                  child: CircularProgressIndicator()))
        else if (vm.transactions.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            padding: const EdgeInsets.only(top: AppSizes.p20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vm.transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                _buildActivityCard(vm.transactions[index]),
          ),
      ],
    );
  }

  Widget _buildFilterTab(
      HoldingDetailsViewModel vm, TransactionFilter filter, String label) {
    final isSelected = vm.currentFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => vm.setFilter(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: isSelected ? AppColors.textPrimary : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(Transaction t) {
    final isBuy = t.type == TransactionType.buy;
    final isDiv = t.type == TransactionType.dividend;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDiv
                      ? Colors.blue
                      : (isBuy ? AppColors.primary : AppColors.error))
                  .withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDiv
                  ? Icons.payments
                  : (isBuy
                      ? Icons.add_shopping_cart
                      : Icons.remove_shopping_cart),
              color: isDiv
                  ? Colors.blue
                  : (isBuy ? AppColors.primary : AppColors.error),
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.typeString,
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
                Text(
                  '${AppFormatters.dateOnly.format(t.date)} • ${isDiv ? 'Final Dividend' : 'CDS Account'}',
                  style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isDiv
                    ? AppFormatters.formatCurrency(t.total_price)
                    : '${t.qty.toInt()} Shares',
                style: GoogleFonts.inter(
                  color: isDiv ? Colors.blue : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                isDiv
                    ? 'Credited'
                    : '@ ${AppFormatters.formatCurrency(t.unit_price)}',
                style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: AppSizes.p20),
      padding: const EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('No activity matching this filter',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.95),
        border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('SELL',
                  style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
              ),
              child: Text('BUY MORE',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2)),
            ),
          ),
        ],
      ),
    );
  }
}
