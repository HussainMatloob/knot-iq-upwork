import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAndTimePicker {
  /// Opens a date picker and returns the selected date
  static Future<DateTime?> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return selectedDate;
  }

  /// Opens a time picker and returns the selected time
  static Future<TimeOfDay?> pickTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: now,
    );
    return selectedTime;
  }

  /// Opens both date and time pickers, and returns formatted string like "25 Oct , 09:00 PM"
  static Future<String?> pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return null;

    final time = await pickTime(context);
    if (time == null) return null;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final formattedDate = DateFormat("dd MMM, hh:mm a").format(dateTime);
    return formattedDate;
  }

  static String getCurrentFormattedDateTime() {
    final now = DateTime.now();
    final formatted = DateFormat("dd MMM, hh:mm a").format(now);
    return formatted;
  }

  static DateTime parseFormattedDate(String formatted) {
    return DateFormat("dd MMM , hh:mm a").parse(formatted);
  }
}
