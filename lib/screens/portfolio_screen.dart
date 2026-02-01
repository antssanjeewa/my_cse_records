import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/holding.dart';
import '../viewmodels/portfolio_viewmodel.dart';
import 'package:go_router/go_router.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PortfolioViewModel>(context);
    final currencyFormat =
        NumberFormat.currency(locale: 'en_LK', symbol: 'Rs. ');
    final defaultNumberFormat = NumberFormat('#,##0');

    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: const Color(0xFF101322).withOpacity(0.9),
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 20),
              onPressed: () => context.go('/home'),
            ),
            title: Text('Portfolio Holdings',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white)),
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
                    top: 100, left: 16, right: 16, bottom: 16),
                child: _buildSummaryCard(viewModel, currencyFormat),
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
                color: const Color(0xFF101322),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Search
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF191E33),
                        hintText: 'Search ticker or company...',
                        hintStyle: const TextStyle(color: Color(0xFF929BC9)),
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF929BC9)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFF323B67))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFF323B67))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFF1337EC))),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildChip('Sort: Profit %', true),
                          _buildChip('Market Value', false),
                          _buildChip('Sector', false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final holding = viewModel.holdings[index];
                  return _buildHoldingCard(
                      holding, currencyFormat, defaultNumberFormat);
                },
                childCount: viewModel.holdings.length,
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(PortfolioViewModel vm, NumberFormat fmt) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1337EC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1337EC).withOpacity(0.3),
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
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(fmt.format(vm.totalValue),
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    const Text('+2.4% Today',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('Market: Open',
                  style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.7), fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF1337EC) : const Color(0xFF191E33),
        borderRadius: BorderRadius.circular(20),
        border: active ? null : Border.all(color: const Color(0xFF323B67)),
      ),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  color: active ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          Icon(Icons.expand_more,
              size: 16, color: active ? Colors.white : Colors.white70),
        ],
      ),
    );
  }

  Widget _buildHoldingCard(Holding h, NumberFormat fmt, NumberFormat numFmt) {
    final profit = h.profit;
    final profitPct = h.profitPercent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF191E33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF323B67)),
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
                          color: const Color(0xFF1337EC),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0)),
                  Text(h.ticker,
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(h.name,
                      style: GoogleFonts.inter(
                          color: const Color(0xFF929BC9), fontSize: 12)),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: const Color(0xFF232948),
                    borderRadius: BorderRadius.circular(12)),
                child:
                    const Icon(Icons.business, color: Colors.white54, size: 20),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF323B67), height: 1),
          const SizedBox(height: 12),
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
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(text: numFmt.format(h.quantity)),
                          const TextSpan(
                              text: ' @ ',
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(text: h.avgCost.toStringAsFixed(2)),
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
                  Text(fmt.format(h.marketPrice),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
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
                  Text((profit > 0 ? '+' : '') + fmt.format(profit),
                      style: TextStyle(
                          color: profit > 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      (profit > 0 ? Colors.green : Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(profit > 0 ? Icons.trending_up : Icons.trending_down,
                        color:
                            profit > 0 ? Colors.greenAccent : Colors.redAccent,
                        size: 16),
                    const SizedBox(width: 4),
                    Text(
                        '${profitPct > 0 ? '+' : ''}${profitPct.toStringAsFixed(2)}%',
                        style: TextStyle(
                            color: profit > 0
                                ? Colors.greenAccent
                                : Colors.redAccent,
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
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) => false;
}
