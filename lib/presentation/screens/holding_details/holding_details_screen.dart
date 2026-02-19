import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../viewmodels/holding_details_viewmodel.dart';
import 'widgets/activity_list_section.dart';
import 'widgets/current_value_card.dart';
import 'widgets/position_summary_card.dart';

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
                            style: Theme.of(context).textTheme.titleLarge),
                        Row(
                          children: [
                            Text(h.name,
                                style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(width: 8),
                            Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                    color: AppColors.textSecondary,
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Icon(getSectorIcon(h.sector),
                                size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(h.sector,
                                style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
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
                          CurrentValueCard(viewModel: viewModel),
                          const SizedBox(height: AppSizes.p20),

                          // 2. Position Summary Card
                          PositionSummaryCard(holding: h),
                          const SizedBox(height: AppSizes.p20),

                          // 3. Recent Activity Section
                          ActivityListSection(viewModel: viewModel),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
