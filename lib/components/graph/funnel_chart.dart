import 'dart:ui';
import 'package:ev_homes/components/my_card.dart';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FunnelChart extends StatefulWidget {
  final String? title;
  final String? centerHeading;
  final String? centerValue;
  final List<ChartModel> initialFunnelData;
  final Function(String filter) onPressFilter;

  const FunnelChart({
    super.key,
    required this.initialFunnelData,
    this.title,
    this.centerHeading,
    this.centerValue,
    required this.onPressFilter,
  });

  @override
  State<FunnelChart> createState() => _FunnelChartState();
}

class _FunnelChartState extends State<FunnelChart> {
  String selectedFilter = "Daily";

  // Define all filter options
  final List<FilterData> filters = [
    // FilterData("Daily", Icons.today),
    FilterData("Weekly", Icons.calendar_view_week),
    FilterData("Monthly", Icons.calendar_view_month),
    FilterData("Quarterly", Icons.calendar_today),
    FilterData("Semi-Annually", Icons.calendar_view_day),
    FilterData("Annually", Icons.calendar_month),
  ];

  @override
  void initState() {
    super.initState();
  }

  FunnelSeries<ChartModel, String> _getFunnelSeries() {
    return FunnelSeries<ChartModel, String>(
      dataSource: widget.initialFunnelData,
      xValueMapper: (ChartModel data, _) => data.category,
      yValueMapper: (ChartModel data, _) => data.value,
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.inside,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total =
        widget.initialFunnelData.fold(0, (sum, item) => sum + item.value);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                SfFunnelChart(
                  title: ChartTitle(text: widget.title ?? 'Sales Funnel'),
                  legend: const Legend(isVisible: true),
                  series: _getFunnelSeries(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: MyCard(
                    bgColor: const Color.fromARGB(255, 252, 242, 163),
                    label: widget.centerHeading ?? "Total",
                    value: total.toInt(),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_alt),
                    onSelected: (String selected) {
                      setState(() {
                        widget.onPressFilter(selected);
                        selectedFilter = selected;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
