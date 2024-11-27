import 'package:flutter/material.dart';

class ChartModel {
  final String category;
  final double value;

  ChartModel({
    required this.category,
    required this.value,
  });
}

class FilterData {
  final String label;
  final IconData icon;

  FilterData(this.label, this.icon);
}
