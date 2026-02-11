import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/widgets.dart';
import 'widgets/home_allocation_row.dart';
import 'widgets/home_hero_card.dart';
import 'widgets/home_loading_skeleton.dart';
import 'widgets/home_recent_transactions.dart';
import 'widgets/home_transaction_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          final summary = viewModel.summary;
          final isInitialLoad = viewModel.isLoading && summary == null;

          return RefreshIndicator(
            onRefresh: () => viewModel.fetchSummary(),
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: AppColors.background.withValues(alpha: 0.9),
                  floating: true,
                  leading: Container(
                    margin: const EdgeInsets.only(left: AppSizes.p20),
                    child: Hero(
                      tag: 'app_logo_hero',
                      child: Image.asset(
                        AppAssets.logo,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  pinned: true,
                  elevation: 0,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppText.appName,
                        style: AppTextStyles.titleLarge,
                      ),
                      Row(
                        children: [
                          Text(
                            viewModel.isMarketOpen
                                ? 'MARKET OPEN'
                                : 'MARKET CLOSED',
                            style: AppTextStyles.marketStatusOpen.copyWith(
                              color: viewModel.isMarketOpen
                                  ? AppColors.success
                                  : AppColors.warn,
                            ),
                          ),
                          const SizedBox(width: AppSizes.p8),
                          Text(
                            '• ${viewModel.currentTime}',
                            style: AppTextStyles.marketTime.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: AppSizes.p16),
                      child: CircleAvatar(
                        backgroundColor: AppColors.surfaceLight,
                        child: Stack(
                          children: [
                            const Icon(Icons.notifications,
                                color: Colors.white, size: AppSizes.iconMd),
                            Positioned(
                                top: 2,
                                right: 2,
                                child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Loading Indicator
                if (viewModel.isLoading && summary != null)
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

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    child: isInitialLoad
                        ? const HomeLoadingSkeleton()
                        : summary == null
                            ? const Center(
                                child: Text('Unable to load summary',
                                    style: TextStyle(
                                        color: AppColors.textSecondary)),
                              )
                            : Opacity(
                                opacity: viewModel.isLoading ? 0.6 : 1.0,
                                child: Column(
                                  children: [
                                    HomeHeroCard(summary: summary),
                                    const SizedBox(height: AppSizes.p24),
                                    HomeTransactionChart(
                                        transactions:
                                            viewModel.recentTransactions),
                                    const SizedBox(height: AppSizes.p24),
                                    HomeAllocationRow(summary: summary),
                                    const SizedBox(height: AppSizes.p24),
                                    HomeRecentTransactions(
                                        transactions:
                                            viewModel.recentTransactions),
                                  ],
                                ),
                              ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
