import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction.dart';

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
    final currencyFormat =
        NumberFormat.currency(locale: 'en_LK', symbol: 'LKR ');
    final dateFormat = DateFormat('MMM dd • hh:mm a');

    final filteredTransactions = _filter == 'All'
        ? _transactions
        : _transactions.where((t) => t.type == _filter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      body: CustomScrollView(
        slivers: [
          // Sticky Top Bar
          SliverAppBar(
            backgroundColor: const Color(0xFF101322).withOpacity(0.9),
            pinned: true,
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child:
                  Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            ),
            title: Text('Transaction History',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Segmented Control
                  Container(
                    height: 44,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF232948),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildSegment('All'),
                        _buildSegment('Buy'),
                        _buildSegment('Sell'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Date Range
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF191E33),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF323B67)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Color(0xFF1337EC), size: 20),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('DATE RANGE',
                                    style: TextStyle(
                                        color: Color(0xFF929BC9),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0)),
                                const SizedBox(height: 2),
                                Text('Oct 01, 2023 - Oct 31, 2023',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: _buildTransactionItem(t, currencyFormat, dateFormat),
                );
              },
              childCount: filteredTransactions.length,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Icon(Icons.history, color: Colors.white54, size: 32),
                  const SizedBox(height: 8),
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
            color: isSelected
                ? const Color(0xFF101322)
                : Colors.transparent, // "bg-white" equivalent darker
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 2)
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF929BC9),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              )),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      Transaction t, NumberFormat currencyFmt, DateFormat dateFmt) {
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
                    color: isBuy ? const Color(0xFF1337EC) : Colors.grey[700],
                    shape: BoxShape.circle,
                    boxShadow: isBuy
                        ? [
                            const BoxShadow(
                                color: Color(0xFF1337EC),
                                blurRadius: 10,
                                spreadRadius: -2)
                          ]
                        : [],
                  ),
                  child: Icon(isBuy ? Icons.shopping_cart : Icons.sell,
                      color: Colors.white, size: 20),
                ),
                Expanded(
                    child: Container(width: 2, color: const Color(0xFF323B67))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  bottom:
                      24), // Use margin instead of padding wrapper for spacing
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF191E33),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF323B67)), // default border
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
                                  ? const Color(0xFF1337EC).withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(t.type.toUpperCase(),
                                style: TextStyle(
                                    color: isBuy
                                        ? const Color(0xFF1337EC)
                                        : Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 4),
                          Text(t.name,
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(t.ticker,
                              style: const TextStyle(
                                  color: Color(0xFF929BC9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(dateFmt.format(t.date),
                          style: const TextStyle(
                              color: Color(0xFF929BC9), fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFF323B67), height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('QUANTITY',
                              style: TextStyle(
                                  color: Color(0xFF929BC9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('${t.quantity.toInt()} Shares',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PRICE',
                              style: TextStyle(
                                  color: Color(0xFF929BC9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(currencyFmt.format(t.price),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFF323B67), height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Value',
                          style: TextStyle(
                              color: Color(0xFF929BC9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      Text(currencyFmt.format(t.totalValue),
                          style: TextStyle(
                              color: isBuy
                                  ? const Color(0xFF1337EC)
                                  : Colors.white,
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
