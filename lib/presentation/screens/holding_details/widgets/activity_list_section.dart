import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/routing/pages.dart';
import '../../../viewmodels/holding_details_viewmodel.dart';
import 'holding_activity_card.dart';

class ActivityListSection extends StatelessWidget {
  final HoldingDetailsViewModel viewModel;

  const ActivityListSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
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
              InkWell(
                onTap: () => Pages.transactions.go(context),
                child: Text('VIEW ALL',
                    style: GoogleFonts.inter(
                        color: AppColors.info,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ),
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
              _buildFilterTab(viewModel, TransactionFilter.all, 'ALL'),
              _buildFilterTab(viewModel, TransactionFilter.buy, 'BUY'),
              _buildFilterTab(viewModel, TransactionFilter.sell, 'SELL'),
              _buildFilterTab(viewModel, TransactionFilter.dividend, 'DIV'),
            ],
          ),
        ),

        if (viewModel.isLoading)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(AppSizes.p20),
                  child: CircularProgressIndicator()))
        else if (viewModel.transactions.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            padding: const EdgeInsets.only(top: AppSizes.p20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                HoldingActivityCard(transaction: viewModel.transactions[index]),
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
}
