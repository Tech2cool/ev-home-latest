import 'dart:ui';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  final List<ChartModel> chartData;
  final String? title;
  final String? centerHeading;
  final String? centerValue;

  const LineChart({
    super.key,
    required this.chartData,
    this.title,
    this.centerHeading,
    this.centerValue,
  });

  @override
  Widget build(BuildContext context) {
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartData.length * 40,
                child: SfCartesianChart(
                  backgroundColor: Colors.transparent,
                  primaryXAxis: const CategoryAxis(),
                  title: ChartTitle(text: title ?? 'Booking Over Months'),
                  legend: const Legend(isVisible: false),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries>[
                    LineSeries<ChartModel, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartModel data, _) => data.category,
                      yValueMapper: (ChartModel data, _) => data.value,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                        color: Color.fromARGB(255, 176, 39, 39),
                        borderWidth: 2,
                        borderColor: Color.fromARGB(255, 176, 39, 39),
                      ),
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.top,
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 176, 39, 39),
                        ),
                      ),
                      color: const Color.fromARGB(255, 176, 39, 39),
                      dashArray: const <double>[5, 5],
                    ),
                  ],
                  primaryYAxis: const NumericAxis(
                    title: AxisTitle(text: 'Number of Booking'),
                    labelFormat: '{value}',
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    majorGridLines: MajorGridLines(width: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
