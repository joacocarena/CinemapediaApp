import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, [ int decimals = 0 ]) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en'
    ).format(number);
    return formattedNumber;
  }
}