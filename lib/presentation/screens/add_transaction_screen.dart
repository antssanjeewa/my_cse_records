import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/stock.dart';
import '../viewmodels/add_transaction_viewmodel.dart';

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
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
            _buildLabel('Company'),
            const SizedBox(height: AppSizes.p8),
            _buildStockSelector(viewModel),
            const SizedBox(height: AppSizes.p16),

            // Quantity & Unit Price
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Quantity'),
                      const SizedBox(height: AppSizes.p8),
                      _buildTextField(
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
                      _buildLabel('Unit Price (LKR)'),
                      const SizedBox(height: AppSizes.p8),
                      _buildTextField(
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
            _buildLabel('Total Price (LKR)'),
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
            _buildLabel('Date'),
            const SizedBox(height: AppSizes.p8),
            _buildDatePicker(context, viewModel),
            const SizedBox(height: AppSizes.p32),

            // Save Button
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                      final success = await viewModel.saveTransaction();
                      if (success && mounted) {
                        Navigator.of(context).pop();
                      } else if (!success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please fill all fields correctly')),
                        );
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
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

  Widget _buildStockSelector(AddTransactionViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p4),
      child: Autocomplete<Stock>(
        displayStringForOption: (Stock stock) =>
            '${stock.name} (${stock.ticker})',
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<Stock>.empty();
          }
          return viewModel.stocks.where((Stock stock) {
            return stock.name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()) ||
                stock.ticker
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (Stock stock) {
          viewModel.selectStock(stock);
          _priceController.text = stock.lastPrice.toStringAsFixed(2);
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
            decoration: const InputDecoration(
              hintText: 'Search ticker or name',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
              suffixIcon:
                  Icon(Icons.expand_more, color: AppColors.textSecondary),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.r12),
              elevation: 4,
              borderOnForeground: true,
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Stock option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.p16),
                        child: Text(
                          '${option.name} (${option.ticker})',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
      BuildContext context, AddTransactionViewModel viewModel) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: viewModel.date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.surface,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          viewModel.setDate(date);
        }
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                color: AppColors.textSecondary, size: 20),
            const SizedBox(width: AppSizes.p12),
            Text(
              DateFormat('yyyy-MM-dd').format(viewModel.date),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
