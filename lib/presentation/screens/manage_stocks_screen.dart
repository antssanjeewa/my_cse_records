import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/formatters.dart';
import '../viewmodels/manage_stocks_viewmodel.dart';
import '../../domain/entities/stock.dart';

class ManageStocksScreen extends StatefulWidget {
  const ManageStocksScreen({super.key});

  @override
  State<ManageStocksScreen> createState() => _ManageStocksScreenState();
}

class _ManageStocksScreenState extends State<ManageStocksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Manage Stocks',
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Consumer<ManageStocksViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(AppSizes.p16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => viewModel.setSearchQuery(value),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    hintText: 'Search stocks...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textSecondary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              viewModel.setSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                        borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                        borderSide: const BorderSide(color: AppColors.border)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                        borderSide: const BorderSide(color: AppColors.primary)),
                  ),
                ),
              ),

              // Stock List
              Expanded(
                child: viewModel.isLoading && viewModel.filteredStocks.isEmpty
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary))
                    : viewModel.filteredStocks.isEmpty
                        ? const Center(
                            child: Text('No stocks found',
                                style:
                                    TextStyle(color: AppColors.textSecondary)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.p16),
                            itemCount: viewModel.filteredStocks.length,
                            itemBuilder: (context, index) {
                              final stock = viewModel.filteredStocks[index];
                              return _buildStockItem(stock, viewModel);
                            },
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStockDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStockItem(Stock stock, ManageStocksViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.p12),
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.r12),
            ),
            child:
                const Icon(Icons.business, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: AppSizes.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stock.ticker,
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(stock.name,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                if (stock.sector != null)
                  Text(stock.sector!,
                      style: TextStyle(
                          color: AppColors.primary.withAlpha(178),
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(AppFormatters.formatCurrency(stock.lastPrice),
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: AppColors.primary, size: 20),
                    onPressed: () =>
                        _showEditStockDialog(context, stock, viewModel),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.redAccent, size: 20),
                    onPressed: () =>
                        _showDeleteConfirmation(context, stock, viewModel),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Stock stock, ManageStocksViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Stock',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Are you sure you want to delete ${stock.ticker} - ${stock.name}?\n\nThis action cannot be undone.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await viewModel.deleteStock(stock.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${stock.ticker} deleted successfully'),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete stock'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddStockDialog(BuildContext context) {
    final tickerController = TextEditingController();
    final nameController = TextEditingController();
    final sectorController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Add New Stock',
            style: TextStyle(color: AppColors.textPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tickerController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Ticker Symbol',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  hintText: 'e.g., SAMP.N0000',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: sectorController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Sector (Optional)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Last Price',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  prefixText: 'Rs. ',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final ticker = tickerController.text.trim();
              final name = nameController.text.trim();
              final sector = sectorController.text.trim();
              final price = double.tryParse(priceController.text);

              if (ticker.isNotEmpty &&
                  name.isNotEmpty &&
                  price != null &&
                  price > 0) {
                try {
                  await context.read<ManageStocksViewModel>().addStock(
                        ticker: ticker,
                        name: name,
                        sector: sector.isEmpty ? null : sector,
                        lastPrice: price,
                      );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to add stock'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child:
                const Text('Add Stock', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditStockDialog(
      BuildContext context, Stock stock, ManageStocksViewModel viewModel) {
    final priceController =
        TextEditingController(text: stock.lastPrice.toString());
    final sectorController = TextEditingController(text: stock.sector ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Update ${stock.ticker}',
            style: const TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: sectorController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Sector',
                labelStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Last Price',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                prefixText: 'Rs. ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final price = double.tryParse(priceController.text);
              final sector = sectorController.text.trim();

              if (price != null && price > 0) {
                try {
                  await viewModel.updateStock(
                    stockId: stock.id,
                    sector: sector.isEmpty ? null : sector,
                    lastPrice: price,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update stock'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
