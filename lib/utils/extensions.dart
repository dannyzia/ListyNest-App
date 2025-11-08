import 'package:intl/intl.dart';

extension StringCasingExtension on String {
  String toCapitalized() {
    if (isEmpty) return "";
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toTitleCase() {
    if (isEmpty) return "";
    return split(' ').map((str) => str.toCapitalized()).join(' ');
  }
}

extension FormatNumber on num {
  String formatCurrency({
    String locale = 'en_US',
    String symbol = '\$',
    int decimalDigits = 2,
    bool abbreviated = false,
  }) {
    if (abbreviated) {
      if (this >= 1000000000) {
        return '$symbol${(this / 1000000000).toStringAsFixed(1)}B';
      } else if (this >= 1000000) {
        return '$symbol${(this / 1000000).toStringAsFixed(1)}M';
      } else if (this >= 1000) {
        return '$symbol${(this / 1000).toStringAsFixed(1)}K';
      } else {
        return NumberFormat.currency(
          locale: locale,
          symbol: symbol,
          decimalDigits: decimalDigits,
        ).format(this);
      }
    } else {
      return NumberFormat.currency(
        locale: locale,
        symbol: symbol,
        decimalDigits: decimalDigits,
      ).format(this);
    }
  }
}
