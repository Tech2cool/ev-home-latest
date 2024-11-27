import 'dart:ui';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChart extends StatefulWidget {
  final String title;
  final String? centerHeading;
  final String? centerValue;
  final List<ChartModel> chartData;
  final Function(String filter) onPressFilter;

  const DoughnutChart({
    super.key,
    required this.title,
    this.centerHeading,
    this.centerValue,
    required this.chartData,
    required this.onPressFilter,
  });

  @override
  State<DoughnutChart> createState() => _DoughnutChartState();
}

class _DoughnutChartState extends State<DoughnutChart> {
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    double total = widget.chartData.fold(0, (sum, item) => sum + item.value);

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
              border: Border.all(color: Colors.white.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                SfCircularChart(
                  backgroundColor: Colors.transparent,
                  title: ChartTitle(text: widget.title),
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    overflowMode: LegendItemOverflowMode.scroll,
                  ),
                  series: <DoughnutSeries<ChartModel, String>>[
                    DoughnutSeries<ChartModel, String>(
                      dataSource: widget.chartData,
                      xValueMapper: (ChartModel data, _) => data.category,
                      yValueMapper: (ChartModel data, _) => data.value,
                      innerRadius: '60%', // Doughnut shape
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        builder:
                            (data, point, series, pointIndex, seriesIndex) {
                          return Text(
                            '${point.y?.floor()}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.centerHeading ?? 'Total',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.centerValue ?? total.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 120, 4, 4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_alt),
                    onSelected: (String filter) {
                      widget.onPressFilter(filter);
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        // const PopupMenuItem<String>(
                        //   value: "Daily",
                        //   child: Text("Daily"),
                        // ),
                        const PopupMenuItem<String>(
                          value: "Weekly",
                          child: Text("Weekly"),
                        ),
                        const PopupMenuItem<String>(
                          value: "Monthly",
                          child: Text("Monthly"),
                        ),
                        const PopupMenuItem<String>(
                          value: "Quarterly",
                          child: Text("Quarterly"),
                        ),
                        const PopupMenuItem<String>(
                          value: "Semi-Annually",
                          child: Text("Semi-Annually"),
                        ),
                        const PopupMenuItem<String>(
                          value: "yearly",
                          child: Text("Annually"),
                        ),
                      ];
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
