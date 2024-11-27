// lib/funnel_chart.dart
import 'dart:ui';
import 'package:ev_homes/components/my_card.dart';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:ev_homes/core/models/cp_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CpFunnelChart extends StatefulWidget {
  final String? title;
  final String? centerHeading;
  final String? centerValue;
  final List<cpFunnelData> initialcpFunnelData;

  const CpFunnelChart({
    super.key,
    required this.initialcpFunnelData,
    this.title,
    this.centerHeading,
    this.centerValue,
  });

  @override
  _CpFunnelChartState createState() => _CpFunnelChartState();
}

class _CpFunnelChartState extends State<CpFunnelChart> {
  late List<cpFunnelData> funnelData;
  String selectedFilter = "Daily";

  // Define all filter options
  final List<FilterData> filters = [
    FilterData("Daily", Icons.today),
    FilterData("Weekly", Icons.calendar_view_week),
    FilterData("Monthly", Icons.calendar_view_month),
    FilterData("Quarterly", Icons.calendar_today),
    FilterData("Semi-Annually", Icons.calendar_view_day),
    FilterData("Annually", Icons.calendar_month),
  ];

  @override
  void initState() {
    super.initState();
    funnelData = widget.initialcpFunnelData;
  }

  // Dummy method to generate data based on filter
  List<cpFunnelData> getDataBasedOnFilter(String filter) {
    switch (filter) {
      case "Daily":
        return [
          cpFunnelData('Booking Done', 1),
          cpFunnelData('Site Visits Done', 2),
          cpFunnelData('Leads Contacted', 2),
          cpFunnelData('Leads Received', 5),
        ];
      case "Weekly":
        return [
          cpFunnelData('Booking Done', 10),
          cpFunnelData('Site Visits Done', 20),
          cpFunnelData('Leads Contacted', 30),
          cpFunnelData('Leads Received', 50),
        ];
      case "Monthly":
        return [
          cpFunnelData('Booking Done', 150),
          cpFunnelData('Site Visits Done', 200),
          cpFunnelData('Leads Contacted', 300),
          cpFunnelData('Leads Received', 400),
        ];
      case "Quarterly":
        return [
          cpFunnelData('Booking Done', 100),
          cpFunnelData('Site Visits Done', 300),
          cpFunnelData('Leads Contacted', 400),
          cpFunnelData('Leads Received', 600),
        ];
      case "Semi-Annually":
        return [
          cpFunnelData('Booking Done', 250),
          cpFunnelData('Site Visits Done', 320),
          cpFunnelData('Leads Contacted', 300),
          cpFunnelData('Leads Received', 500),
        ];
      case "Annually":
        return [
          cpFunnelData('Booking Done', 400),
          cpFunnelData('Site Visits Done', 600),
          cpFunnelData('Leads Contacted', 750),
          cpFunnelData('Leads Received', 800),
        ];
      default:
        return widget.initialcpFunnelData;
    }
  }

  FunnelSeries<cpFunnelData, String> _getFunnelSeries() {
    return FunnelSeries<cpFunnelData, String>(
      dataSource: funnelData,
      xValueMapper: (cpFunnelData data, _) => data.stage,
      yValueMapper: (cpFunnelData data, _) => data.value,
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.inside,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = funnelData.fold(0, (sum, item) => sum + item.value);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Rounded corners
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 3.0, sigmaY: 3.0), // Adjust blur intensity
          child: Container(
            padding: const EdgeInsets.all(15),
            // decoration: BoxDecoration(
            //   color:
            //       Colors.white.withOpacity(0.2), // Semi-transparent background
            //   border: Border.all(
            //     color:
            //         Colors.white.withOpacity(0.5), // Border color with opacity
            //   ),
            //   borderRadius: BorderRadius.circular(10), // Match ClipRRect radius
            // ),
            child: Stack(
              children: [
                SfFunnelChart(
                  title: const ChartTitle(text: 'Sales Funnel'),
                  legend: const Legend(isVisible: true),
                  series: _getFunnelSeries(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: MyCard(
                    bgColor: const Color.fromARGB(255, 252, 242, 163),
                    label: "Total",
                    value: total.toInt(),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_alt),
                      onSelected: (String selected) {
                        setState(() {
                          selectedFilter = selected;
                          funnelData = getDataBasedOnFilter(selectedFilter);
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return filters.map((FilterData filter) {
                          return PopupMenuItem<String>(
                            value: filter.label,
                            child: ListTile(
                              leading: Icon(filter.icon),
                              title: Text(filter.label),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
