import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/stock.dart';

/// A custom autocomplete search field for stock selection
/// Provides consistent search UX with proper styling and filtering
class CustomStockSearchField extends StatelessWidget {
  final List<Stock> stocks;
  final Function(Stock) onStockSelected;
  final VoidCallback? onClear;
  final String hintText;
  final double maxHeight;

  const CustomStockSearchField({
    super.key,
    required this.stocks,
    required this.onStockSelected,
    this.onClear,
    this.hintText = 'Search ticker or name',
    this.maxHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Stock>(
      displayStringForOption: (Stock stock) =>
          '${stock.name} (${stock.ticker})',
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Stock>.empty();
        }
        final query = textEditingValue.text.toLowerCase();
        return stocks.where((Stock stock) {
          return stock.name.toLowerCase().contains(query) ||
              stock.ticker.toLowerCase().contains(query);
        });
      },
      onSelected: onStockSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: AppTextStyles.bodyMedium,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onFieldSubmitted(),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.hintText,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () {
                          controller.clear();
                          onClear?.call();
                        },
                      )
                    : const Icon(
                        Icons.expand_more,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSizes.p12,
                ),
              ),
            );
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.r12),
            elevation: 8,
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              constraints: BoxConstraints(maxHeight: maxHeight),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Stock option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.p16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.name,
                                  style: AppTextStyles.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  option.ticker,
                                  style: AppTextStyles.captionText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
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
