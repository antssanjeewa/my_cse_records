import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../domain/entities/stock.dart';

/// A custom autocomplete search field for stock selection
class CustomStockSearchField extends StatelessWidget {
  final List<Stock> stocks;
  final Function(Stock) onStockSelected;
  final String? hintText;

  const CustomStockSearchField({
    super.key,
    required this.stocks,
    required this.onStockSelected,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Stock>(
      displayStringForOption: (Stock stock) =>
          '${stock.name} (${stock.ticker})',
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<Stock>.empty();
        }
        return stocks.where((Stock stock) {
          return stock.name
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()) ||
              stock.ticker
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: onStockSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hintText ?? 'Search ticker or name',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon:
                const Icon(Icons.search, color: AppColors.textSecondary),
            suffixIcon:
                const Icon(Icons.expand_more, color: AppColors.textSecondary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }
}
