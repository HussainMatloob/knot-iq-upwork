import 'package:intl/intl.dart';

class DateHelper {
  static String formatDate(String? apiDate) {
    if (apiDate == null || apiDate.isEmpty) return "";

    DateTime date = DateTime.parse(apiDate);
    return DateFormat('MMMM dd, yyyy').format(date); // January 15, 2026
  }

  static String formatStringToDisplay(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return "";

    final dateTime = DateTime.parse(dateTimeString).toLocal(); //  FIX

    return DateFormat("dd MMM, hh:mm a").format(dateTime);
  }

  static String formatDashDate(String? apiDate) {
    try {
      final date = (apiDate == null || apiDate.isEmpty)
          ? DateTime.now()
          : DateTime.parse(apiDate);

      return DateFormat('yyyy-MM-dd').format(date);
    } catch (_) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }
}
