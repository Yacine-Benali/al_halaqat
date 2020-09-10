import 'dart:math';

import 'package:intl/intl.dart';

class Format {
  static String date(DateTime date) {
    return DateFormat.yMMMd('ar').format(date);
  }

  static String dateWithTime(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM yyyy H:m', 'ar');

    return formatter.format(date);
  }

  static double roundDouble(double value) {
    double mod = pow(10.0, 2);
    double result = (value * mod).round().toDouble() / mod;

    return result;
  }
}
