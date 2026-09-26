import 'package:intl/intl.dart';

class AppHelpers {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String formatPrice(double price) {
    return _currencyFormat.format(price);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM, hh:mm a').format(date);
  }

  static String getEstimatedDeliveryDate({int daysToAdd = 4}) {
    final targetDate = DateTime.now().add(Duration(days: daysToAdd));
    return DateFormat('EEEE, d MMMM').format(targetDate);
  }

  static double calculateDiscountPercent(double originalPrice, double currentPrice) {
    if (originalPrice <= 0 || currentPrice >= originalPrice) return 0;
    return (((originalPrice - currentPrice) / originalPrice) * 100).roundToDouble();
  }
}
