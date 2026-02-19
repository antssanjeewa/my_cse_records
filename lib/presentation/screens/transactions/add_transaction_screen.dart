import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../domain/entities/transaction.dart';
import '../../viewmodels/add_transaction_viewmodel.dart';
import '../../viewmodels/portfolio_viewmodel.dart';
import '../../viewmodels/transaction_history_viewmodel.dart';
import '../../widgets/widgets.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddTransactionViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add Transaction',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Buy/Sell Toggle
            _buildTypeToggle(viewModel),
            const SizedBox(height: AppSizes.p24),

            // Company Selection
            const CustomLabel(text: 'Company'),
            const SizedBox(height: AppSizes.p8),
            CustomStockSearchField(
              stocks: viewModel.stocks,
              onStockSelected: (stock) {
                viewModel.selectStock(stock);
              },
              onClear: () {
                viewModel.selectStock(null);
                _qtyController.clear();
                _priceController.clear();
                viewModel.setQuantity(0);
                viewModel.setUnitPrice(0);
              },
            ),
            const SizedBox(height: AppSizes.p16),

            // Current Holding Details Card
            if (viewModel.selectedStock != null)
              Container(
                margin: const EdgeInsets.only(bottom: AppSizes.p24),
                padding: const EdgeInsets.all(AppSizes.p16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.p12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                      ),
                      child: const Icon(Icons.account_balance_wallet,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: AppSizes.p16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Current Position',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildPositionStat(
                                label: 'Quantity',
                                value: AppFormatters.formatNumber(
                                    viewModel.currentHolding?.quantity ?? 0),
                              ),
                              const SizedBox(width: 24),
                              _buildPositionStat(
                                label: 'Avg. Price',
                                value: AppFormatters.formatCurrency(
                                    viewModel.currentHolding?.avgPrice ?? 0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Quantity & Unit Price
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomLabel(text: 'Quantity'),
                      const SizedBox(height: AppSizes.p8),
                      CustomTextField(
                        controller: _qtyController,
                        hint: '0',
                        onChanged: (val) =>
                            viewModel.setQuantity(double.tryParse(val) ?? 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.p16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomLabel(text: 'Unit Price (LKR)'),
                      const SizedBox(height: AppSizes.p8),
                      CustomTextField(
                        controller: _priceController,
                        hint: '0.00',
                        onChanged: (val) =>
                            viewModel.setUnitPrice(double.tryParse(val) ?? 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p16),

            // Total Price
            const CustomLabel(text: 'Total Price (LKR)'),
            const SizedBox(height: AppSizes.p8),
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSizes.r12),
                border: Border.all(color: AppColors.border),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                AppFormatters.formatCurrency(viewModel.totalPrice),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '* Includes estimated CSE transaction fees',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppSizes.p16),

            // Date Picker
            const CustomLabel(text: 'Date'),
            const SizedBox(height: AppSizes.p8),
            CustomDateField(
              selectedDate: viewModel.date,
              onDateSelected: viewModel.setDate,
            ),
            const SizedBox(height: AppSizes.p32),

            // Save Button
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                      final success = await viewModel.saveTransaction();
                      if (success && mounted) {
                        // Refresh portfolio and transaction history
                        if (context.mounted) {
                          context.read<PortfolioViewModel>().fetchHoldings();
                          context
                              .read<TransactionHistoryViewModel>()
                              .fetchTransactions();
                        }
                        Navigator.of(context).pop();
                        AppSnackBar.show(context,
                            message: 'Transaction added successfully',
                            isError: false);
                      } else if (!success && mounted) {
                        AppSnackBar.show(context,
                            message: viewModel.errorMessage ??
                                'An unknown error occurred',
                            isError: true);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                ),
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.2),
              ),
              child: viewModel.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Save Transaction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: AppSizes.p16),
            const Text(
              'This transaction will be reflected in your portfolio immediately.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggle(AddTransactionViewModel viewModel) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton(
              label: 'Buy',
              isSelected: viewModel.type == TransactionType.buy,
              onTap: () => viewModel.setType(TransactionType.buy),
            ),
          ),
          Expanded(
            child: _buildTypeButton(
              label: 'Sell',
              isSelected: viewModel.type == TransactionType.sell,
              onTap: () => viewModel.setType(TransactionType.sell),
            ),
          ),
          Expanded(
            child: _buildTypeButton(
              label: 'Dividend',
              isSelected: viewModel.type == TransactionType.dividend,
              onTap: () => viewModel.setType(TransactionType.dividend),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceLight : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.r8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  )
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPositionStat({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
