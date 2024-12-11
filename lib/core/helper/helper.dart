import 'package:ev_homes/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static String formatDate(String dateString) {
    // List of possible date formats
    final List<String> formats = [
      'dd MMM yyyy',
      'yyyy-MM-dd',
      'yyyy-MM-dd hh:mm',
      'dd MMMM yyyy',
      'dd/MM/yyyy',
      // Include ISO 8601 format
      'yyyy-MM-ddTHH:mm:ss.SSSZ', // ISO format with timezone
    ];

    for (String format in formats) {
      try {
        // Parse the date string
        final DateFormat dateFormat = DateFormat(format);

        // Check for ISO 8601 format separately
        DateTime dateTime;
        if (format == 'yyyy-MM-ddTHH:mm:ss.SSSZ') {
          dateTime = DateTime.parse(dateString); // Parse ISO format
        } else {
          dateTime = dateFormat.parseStrict(dateString);
        }

        // Convert to local timezone
        dateTime = dateTime.toLocal();

        // Define the desired output format
        final DateFormat outputFormatter = DateFormat('dd MMM yy HH:mm');

        // Format the DateTime object into the desired string format
        return outputFormatter.format(dateTime);
      } catch (e) {
        // Continue to the next format if parsing fails
        continue;
      }
    }

    // If no format matched, return "NA"
    return "NA";
  }

  static String formatDateLong(String dateString) {
    // List of possible date formats
    final List<String> formats = [
      'dd MMM yyyy',
      'yyyy-MM-dd',
      'yyyy-MM-dd hh:mm',
      'dd MMMM yyyy',
      'dd/MM/yyyy',
      // Include ISO 8601 format
      'yyyy-MM-ddTHH:mm:ss.SSSZ', // ISO format with timezone
      'yyyy-MM-ddTHH:mm:ss.SSSZ', // ISO format with Z
    ];

    for (String format in formats) {
      try {
        // Parse the date string
        final DateFormat dateFormat = DateFormat(format);

        // Check for ISO 8601 format separately
        DateTime dateTime;
        if (format == 'yyyy-MM-ddTHH:mm:ss.SSSZ' ||
            format == 'yyyy-MM-ddTHH:mm:ss.SSSZ') {
          dateTime = DateTime.parse(dateString); // Parse ISO format
        } else {
          dateTime = dateFormat.parseStrict(dateString);
        }

        // Define the desired output format
        final DateFormat outputFormatter = DateFormat('d MMMM yyyy HH:mm');

        // Format the DateTime object into the desired string format
        return outputFormatter.format(dateTime);
      } catch (e) {
        // Continue to the next format if parsing fails
        continue;
      }
    }

    // If no format matched, return "NA"
    return "NA";
  }

  static String formatDateOnly(String dateString) {
    // List of possible date formats
    final List<String> formats = [
      'dd MMM yyyy',
      'yyyy-MM-dd',
      'yyyy-MM-dd hh:mm',
      'dd MMMM yyyy',
      'dd/MM/yyyy',
      // Include ISO 8601 format
      'yyyy-MM-ddTHH:mm:ss.SSSZ', // ISO format with timezone
      'yyyy-MM-ddTHH:mm:ss.SSSZ', // ISO format with Z
    ];

    for (String format in formats) {
      try {
        // Parse the date string
        final DateFormat dateFormat = DateFormat(format);

        // Check for ISO 8601 format separately
        DateTime dateTime;
        if (format == 'yyyy-MM-ddTHH:mm:ss.SSSZ' ||
            format == 'yyyy-MM-ddTHH:mm:ss.SSSZ') {
          dateTime = DateTime.parse(dateString); // Parse ISO format
        } else {
          dateTime = dateFormat.parseStrict(dateString);
        }

        // Define the desired output format
        final DateFormat outputFormatter = DateFormat('dd MMM yyyy');

        // Format the DateTime object into the desired string format
        return outputFormatter.format(dateTime);
      } catch (e) {
        // Continue to the next format if parsing fails
        continue;
      }
    }

    // If no format matched, return "NA"
    return "NA";
  }

  static bool isWithin60Days(String dateString) {
    // Parse the date string
    DateTime inputDate = DateFormat('yyyy-MM-dd HH:mm').parse(dateString);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference in days
    int differenceInDays = currentDate.difference(inputDate).inDays;

    // Return true if the difference is within 60 days
    return differenceInDays.abs() <= 60;
  }

  static String getShortMonthName(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('MMM', 'en_US');
    return formatter.format(date);
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'in progress':
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  static Color getIntrestedColor(String status) {
    switch (status.toLowerCase()) {
      case 'cold':
        return Colors.blue;
      case 'hot':
        return Colors.red;
      case 'warm':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  static void showCustomSnackBar(String message,
      [Color bgColor = Colors.red, Color color = Colors.white]) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: color,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      backgroundColor: bgColor,
    );
    scaffoldMessengerKey.currentState?.clearSnackBars();
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  static String formatNumber(double number) {
    if (number >= 10000000) {
      double crore = number / 10000000;
      return '${crore.toStringAsFixed(crore.truncateToDouble() == crore ? 0 : 1)}cr';
    } else if (number >= 100000) {
      double lakh = number / 100000;
      return '${lakh.toStringAsFixed(lakh.truncateToDouble() == lakh ? 0 : 1)}lakh';
    } else if (number >= 1000) {
      double k = number / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}k';
    } else {
      return number
          .toStringAsFixed(number.truncateToDouble() == number ? 0 : 1);
    }
  }

  static String formatIndianNumber(number) {
    if (number < 1000) {
      return number.toString(); // Less than a thousand
    } else if (number < 100000) {
      // Thousands
      return "${(number / 1000).toStringAsFixed(1)}K";
    } else if (number < 10000000) {
      // Lakhs
      return "${(number / 100000).toStringAsFixed(1)}L";
    } else {
      // Crores
      return "${(number / 10000000).toStringAsFixed(1)}Cr";
    }
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static bool hasValueChanged(dynamic oldValue, dynamic newValue) {
    return oldValue != newValue;
  }

  static String maskPhoneNumber(String input) {
    if (input.length <= 4) {
      return input;
    }
    // Mask all but the last four digits
    return '*' * (input.length - 4) + input.substring(input.length - 4);
  }
}
