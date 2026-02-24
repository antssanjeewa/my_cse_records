import 'package:intl/intl.dart';
import '../constants/app_config.dart';

class AppFormatters {
  static final NumberFormat currency = NumberFormat.currency(
      locale: AppConfig.locale, symbol: AppConfig.currencySymbol);

  static final NumberFormat currencyShort = NumberFormat.currency(
      locale: AppConfig.locale, symbol: AppConfig.currencySymbolShort);

  static final NumberFormat number = NumberFormat('#,##0');

  static final DateFormat dateDetailed = DateFormat('MMM dd • hh:mm a');
  static final DateFormat dateSimple = DateFormat('MMM dd, yyyy');
  static final DateFormat dateOnly = DateFormat('MMM dd, yyyy');

  static String formatCurrency(double value) => currency.format(value);
  static String formatNumber(num value) => number.format(value);

  static double roundTo(double value, [int precision = 4]) {
    return double.parse(value.toStringAsFixed(precision));
  }
}
