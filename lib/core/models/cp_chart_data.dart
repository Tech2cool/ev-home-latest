// lib/models.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Represents the data for charts like Bar, Line, and Doughnut.
class CpChartData {
  CpChartData(this.category, this.value);
  final String category;
  final double value;
}

/// Represents filter options with a label and an icon.
class CpFilterData {
  final String label;
  final IconData icon;

  CpFilterData(this.label, this.icon);
}

/// Represents the data for Funnel Charts.
class cpFunnelData {
  cpFunnelData(this.stage, this.value);
  final String stage;
  final double value;
}

/// Represents a lead in the system.
class LeadModel {
  final ChannelPartner? channelPartner;
  final String status;
  final String startDate;

  LeadModel({
    this.channelPartner,
    required this.status,
    required this.startDate,
  });
}

/// Represents a Channel Partner.
class ChannelPartner {
  final String name;

  ChannelPartner({required this.name});
}

/// Helper class for utility functions.
class Helper {
  /// Formats a date string to 'dd MMM yyyy'.
  static String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  /// Retrieves the short month name from a date string.
  static String getShortMonthName(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM').format(date);
    } catch (e) {
      return '';
    }
  }
}
