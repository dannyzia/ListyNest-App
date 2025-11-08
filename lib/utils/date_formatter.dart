import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date) {
    return DateFormat.yMd().add_jm().format(date);
  }
}
