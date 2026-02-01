import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/transaction.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _filter = 'All'; // All, Buy, Sell

  final List<Transaction> _transactions = [
    Transaction(
        id: '1',
        ticker: 'JKH.N0000',
        name: 'John Keells Holdings PLC',
        type: 'Buy',
        date: DateTime(2023, 10, 24, 10, 15),
        quantity: 100,
        price: 192.50),
    Transaction(
        id: '2',
        ticker: 'SAMP.N0000',
        name: 'Sampath Bank PLC',
        type: 'Sell',
        date: DateTime(2023, 10, 22, 14, 30),
        quantity: 500,
        price: 74.20),
    Transaction(
        id: '3',
        ticker: 'HAYL.N0000',
        name: 'Hayleys PLC',
        type: 'Buy',
        date: DateTime(2023, 10, 20, 11, 00),
        quantity: 250,
        price: 82.50),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _filter == 'All'
        ? _transactions
        : _transactions.where((t) => t.type == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Sticky Top Bar
          SliverAppBar(
            backgroundColor: AppColors.background.withValues(alpha: 0.9),
            pinned: true,
            leading: const Padding(
              padding: EdgeInsets.all(AppSizes.p8),
              child: Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, size: AppSizes.iconMd),
            ),
            title: Text(AppText.transactionHistory,
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.textPrimary),
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
                        _buildSegment('All'),
                        _buildSegment('Buy'),
                        _buildSegment('Sell'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.p16),
                  // Date Range
                  Container(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('DATE RANGE',
                                    style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0)),
                                const SizedBox(height: 2),
                                Text('Oct 01, 2023 - Oct 31, 2023',
                                    style: GoogleFonts.inter(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                        const Icon(Icons.expand_more, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

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
                      'Showing ${filteredTransactions.length} transactions from Oct 2023',
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 80), // Bottom padding
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSegment(String label) {
    final isSelected = _filter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filter = label),
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

  Widget _buildTransactionItem(Transaction t) {
    final isBuy = t.type == 'Buy';
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
              margin: const EdgeInsets.only(
                  bottom:
                      24), // Use margin instead of padding wrapper for spacing
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r16),
                border: Border.all(color: AppColors.border), // default border
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
                            child: Text(t.type.toUpperCase(),
                                style: TextStyle(
                                    color:
                                        isBuy ? AppColors.primary : Colors.grey,
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
                              color: isBuy
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
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
