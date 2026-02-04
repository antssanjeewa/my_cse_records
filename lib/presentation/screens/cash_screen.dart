import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/snackbar_util.dart';
import '../../domain/entities/cash_transaction.dart';
import '../viewmodels/cash_viewmodel.dart';
import '../widgets/widgets.dart';

class CashScreen extends StatelessWidget {
  const CashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Cash Balance',
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Consumer<CashViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.transactions.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          return Column(
            children: [
              // Balance Card
              Container(
                margin: const EdgeInsets.all(AppSizes.p16),
                padding: const EdgeInsets.all(AppSizes.p20),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF1E88E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.r20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      AppFormatters.formatCurrency(viewModel.balance),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildQuickAction(
                          context,
                          'Deposit',
                          Icons.add,
                          () => _showTransactionDialog(
                              context, viewModel, 'DEPOSIT'),
                        ),
                        const SizedBox(width: 12),
                        _buildQuickAction(
                          context,
                          'Withdraw',
                          Icons.remove,
                          () => _showTransactionDialog(
                              context, viewModel, 'WITHDRAWAL'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Transactions Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Text('RECENT TRANSACTIONS',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2)),
                  ],
                ),
              ),

              // Transaction List
              Expanded(
                child: viewModel.transactions.isEmpty
                    ? const Center(
                        child: Text('No transactions yet',
                            style: TextStyle(color: AppColors.textSecondary)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: viewModel.transactions.length,
                        itemBuilder: (context, index) {
                          final tx = viewModel.transactions[index];
                          return _buildTransactionItem(tx);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickAction(
      BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(AppSizes.r12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(CashTransaction tx) {
    final bool isCredit = tx.amount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isCredit ? AppColors.success : AppColors.error)
                  .withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isCredit ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.type,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold)),
                Text(tx.description ?? 'System Transaction',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : ''}${AppFormatters.formatCurrency(tx.amount)}',
                style: TextStyle(
                    color: isCredit ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppFormatters.dateOnly.format(tx.createdAt),
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTransactionDialog(
      BuildContext context, CashViewModel viewModel, String type) {
    final amountController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text('$type Cash',
                  style: const TextStyle(color: AppColors.textPrimary)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomLabel(text: 'Amount'),
                      const SizedBox(height: AppSizes.p8),
                      CustomTextField(
                        controller: amountController,
                        hint: '0',
                        prefixText: 'Rs. ',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomLabel(text: 'Description (Optional)'),
                      const SizedBox(height: AppSizes.p8),
                      CustomTextField(
                        controller: descController,
                        keyboardType: TextInputType.text,
                        hint: '',
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          final amount = double.tryParse(amountController.text);

                          final error = await viewModel.addTransaction(
                            amount: amount,
                            type: type,
                            description: descController.text.isEmpty
                                ? null
                                : descController.text,
                          );
                          if (context.mounted) {
                            if (error == null) {
                              Navigator.pop(context);
                            }

                            AppSnackBar.show(context,
                                message:
                                    error ?? 'Transaction added successfully',
                                isError: error != null);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withAlpha(50)),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Confirm',
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }),
    );
  }
}
