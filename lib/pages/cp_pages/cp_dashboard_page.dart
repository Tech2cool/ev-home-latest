import 'package:ev_homes/components/cp_videoplayer.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/core/models/tagging_form_model.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/cp_pages/client_report.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = false;

  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    setState(() {
      isLoading = true;
    });
    try {
      // await settingProvider.searchLead();
      await settingProvider.searchLeadChannelPartner(
        settingProvider.loggedChannelPartner!.id!,
      );

      // await settingProvider.getOurProject();
    } catch (e) {
      // Helper
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final cpLeads = settingProvider.searchLeadsChannelPartner;
    print(cpLeads);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFF042630),
          ),
        ),
      ),
      body: Stack(
        children: [
          CpVideoplayer(),
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Color.fromARGB(44, 134, 185, 176), // Start color
          //         Color.fromARGB(44, 76, 114, 115),
          //         // Color.fromARGB(199, 248, 85, 4),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ClientReport(selectedFilter: 'All'),
                              ),
                            );
                          },
                          child: _buildLabelBox(
                              cpLeads.totalItems.toString(), 'Leads'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ClientReport(
                                    selectedFilter: 'Approved'),
                              ),
                            );
                          },
                          child: _buildLabelBox(
                              cpLeads.approvedCount.toString(),
                              'Approved'), // Dummy data for "Approved"
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ClientReport(
                                    selectedFilter: 'Rejected'),
                              ),
                            );
                          },
                          child: _buildLabelBox(
                              cpLeads.rejectedCount.toString(),
                              'Rejected'), // Dummy data for "Rejected"
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ClientReport(
                                    selectedFilter: 'Pending'),
                              ),
                            );
                          },
                          child: FittedBox(
                            child: _buildLabelBox(
                                cpLeads.pendingCount.toString(),
                                'In progress'), // Dummy data for "In Progress"
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const LineChartDemo(list: []), // Dummy data for charts
                  const SizedBox(height: 20),
                  const PieChartDemo(leads: []), // Dummy data for charts
                  const SizedBox(height: 20),
                  const FunnelChartDemo(leads: []), // Dummy data for charts
                  const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelBox(String quantity, String label) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            offset: const Offset(0, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quantity,
            style: const TextStyle(
              fontSize: 20.0,
              color: Color.fromARGB(255, 16, 18, 19),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.0,
              color: Color(0xFF042630),
            ),
          ),
        ],
      ),
    );
  }
}

class LabelsDemo extends StatelessWidget {
  const LabelsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
          child: Text(
            'Below is a summary of your day.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
            child: ListView(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 8.0, 8.0),
                  child: _buildTaskBox(
                    title: '16',
                    subtitle: 'New Activity',
                    textColor: Colors.black87,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 8.0),
                  child: _buildTaskBox(
                    title: '16',
                    subtitle: 'Current Tasks',
                    textColor: Colors.deepPurpleAccent,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 8.0),
                  child: _buildTaskBox(
                    title: '16',
                    subtitle: 'Completed Tasks',
                    textColor: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskBox({
    required String title,
    required String subtitle,
    required Color textColor,
  }) {
    return Container(
      width: 130.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color(0xFFE0E3E7),
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF042630),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartDemo extends StatefulWidget {
  const LineChartDemo({super.key, required List list});

  @override
  State<LineChartDemo> createState() => _LineChartDemoState();
}

class _LineChartDemoState extends State<LineChartDemo> {
  String _selectedFilter = 'Weekly';

  @override
  Widget build(BuildContext context) {
    // Generate chart data based on hard-coded values
    List<FlSpot> chartData = _generateChartData();

    final xLabels = _getXAxisLabels();
    final xMax = xLabels.length - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(70),
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(width: 0.5, color: Colors.black26),
        // boxShadow: [
        //   BoxShadow(
        //     color: Color.fromARGB(255, 133, 0, 0)
        //         .withOpacity(0.8), // Grey shadow color
        //     offset: Offset(3, 3), // Position the shadow
        //     blurRadius: 8, // Blur effect
        //     spreadRadius: 3, // Spread the shadow
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Leads',
                style: TextStyle(
                  color: Color(0xFF042630),
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              DropdownButton<String>(
                value: _selectedFilter,
                items: <String>['Weekly', 'Monthly', 'Yearly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFilter = newValue!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1000,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toString());
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < xLabels.length) {
                              return Text(xLabels[index]);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: xMax.toDouble(),
                    minY: 0,
                    maxY: 100, // Adjust this value based on your y-values
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartData,
                        isCurved: true,
                        color: Constant.bgColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Constant.bgColor.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateChartData() {
    List<FlSpot> chartData = [];

    if (_selectedFilter == 'Weekly') {
      // Hard-coded data for weekly
      chartData = [
        const FlSpot(0, 2), // Monday
        const FlSpot(1, 3), // Tuesday
        const FlSpot(2, 5), // Wednesday
        const FlSpot(3, 1), // Thursday
        const FlSpot(4, 4), // Friday
        const FlSpot(5, 6), // Saturday
        const FlSpot(6, 2), // Sunday
      ];
    } else if (_selectedFilter == 'Monthly') {
      // Hard-coded data for monthly
      chartData = [
        const FlSpot(0, 10), // January
        const FlSpot(1, 15), // February
        const FlSpot(2, 8), // March
        const FlSpot(3, 12), // April
        const FlSpot(4, 14), // May
        const FlSpot(5, 20), // June
        const FlSpot(6, 18), // July
        const FlSpot(7, 25), // August
        const FlSpot(8, 17), // September
        const FlSpot(9, 22), // October
        const FlSpot(10, 30), // November
        const FlSpot(11, 28), // December
      ];
    } else {
      // Hard-coded data for yearly
      chartData = [
        const FlSpot(0, 10), // 2020
        const FlSpot(1, 23), // 2021
        const FlSpot(2, 25), // 2022
        const FlSpot(3, 20),
        const FlSpot(4, 10),
        const FlSpot(5, 50),
        const FlSpot(6, 60),
        const FlSpot(7, 70),
        const FlSpot(8, 80),
        const FlSpot(9, 70),
        const FlSpot(10, 80), // 2024 (and so on...)
      ];
    }

    return chartData;
  }

  List<String> _getXAxisLabels() {
    List<String> labels = [];

    if (_selectedFilter == 'Weekly') {
      labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    } else if (_selectedFilter == 'Monthly') {
      labels = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
    } else if (_selectedFilter == 'Yearly') {
      labels = List.generate(10, (i) => (2020 + i).toString());
    }

    return labels;
  }
}

class PieChartDemo extends StatefulWidget {
  const PieChartDemo({super.key, required List leads});

  @override
  State<PieChartDemo> createState() => _PieChartDemoState();
}

class _PieChartDemoState extends State<PieChartDemo> {
  @override
  Widget build(BuildContext context) {
    // Dummy data for the lead counts
    final leadCounts = {
      'Approved': 50,
      'In Progress': 30,
      'Rejected': 20,
    };

    // Prepare the chart data with dummy values
    final chartData = [
      PieChartSectionData(
        color: Colors.green, // Approved color
        value: leadCounts['Approved']!.toDouble(),
        title: '${leadCounts['Approved']}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange, // In Progress color
        value: leadCounts['In Progress']!.toDouble(),
        title: '${leadCounts['In Progress']}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red, // Rejected color
        value: leadCounts['Rejected']!.toDouble(),
        title: '${leadCounts['Rejected']}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3), // Semi-transparent container
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            offset: const Offset(0, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tagging Status',
                style: TextStyle(
                  color: Color(0xFF042630),
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 150,
                child: PieChart(
                  PieChartData(
                    sections: chartData,
                    startDegreeOffset: 20,
                    centerSpaceRadius: 40,
                    sectionsSpace: 0,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Leads',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF042630),
                    ),
                  ),
                  Text(
                    '${leadCounts['Approved']! + leadCounts['In Progress']! + leadCounts['Rejected']!}', // Total leads count (dummy data)
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF042630),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LegendItem(color: Colors.green, text: 'Approved'),
              LegendItem(color: Colors.orange, text: 'In Progress'),
              LegendItem(color: Colors.red, text: 'Rejected'),
            ],
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Color(0xFF042630)),
        ),
      ],
    );
  }
}

class FunnelChartDemo extends StatefulWidget {
  final List<TaggingForm> leads;

  const FunnelChartDemo({super.key, required this.leads});

  @override
  State<FunnelChartDemo> createState() => _FunnelChartDemoState();
}

class _FunnelChartDemoState extends State<FunnelChartDemo> {
  final String _selectedFilter = "Last Week";
  late Map<String, List<Map<String, String>>> _funnelData;
  bool isLoading = false;

  // final Map<String, Color> _stageColors = {
  //   "Total": Colors.blue,
  //   "NoResponse": Colors.red,
  //   "NotInterested": Colors.orange,
  //   "Pipelined": Colors.purple,
  //   "Site visited": Colors.green,
  //   "Booked": Colors.teal,
  // };

  // Future<void> _onRefresh() async {
  //   final settingProvider = Provider.of<SettingProvider>(
  //     context,
  //     listen: false,
  //   );
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await settingProvider.getPostSaleLead();
  //     await settingProvider.getOurProject();
  //     await settingProvider.getDesignation();
  //     await settingProvider.getDivision();
  //     await settingProvider.getDepartment();
  //   } catch (e) {
  //     //
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();

    _funnelData = _generateFunnelData();
  }

  Map<String, List<Map<String, String>>> _generateFunnelData() {
    return {
      "Last Week": _getFunnelDataForPeriod(
          DateTime.now().subtract(const Duration(days: 7))),
      "Last Month": _getFunnelDataForPeriod(
          DateTime.now().subtract(const Duration(days: 30))),
      "Last Year": _getFunnelDataForPeriod(
          DateTime.now().subtract(const Duration(days: 365))),
    };
  }

  List<Map<String, String>> _getFunnelDataForPeriod(DateTime startDate) {
    int noresponse = 22;
    int notInterested = 33;
    int pipelined = 30;
    int siteVisited = 10;
    int booked = 40;
    int total = noresponse + notInterested + pipelined + siteVisited + booked;

    for (var lead in widget.leads) {
      DateTime leadDate = DateTime.parse(lead.startDate);

      if (leadDate.isAfter(startDate)) {
        total++;
        if (lead.taggingStatus == 'NoResponse') noresponse++;
        if (lead.taggingStatus == 'NotInterested') notInterested++;
        if (lead.taggingStatus == 'Pipelined') pipelined++;
        if (lead.taggingStatus == 'Site visited') siteVisited++;
        if (lead.taggingStatus == 'Booked') booked++;
      }
    }

    return [
      {"label": "Total", "value": total.toString()},
      {"label": "NoResponse", "value": noresponse.toString()},
      {"label": "NotInterested", "value": notInterested.toString()},
      {"label": "Pipelined", "value": pipelined.toString()},
      {"label": "Site visited", "value": siteVisited.toString()},
      {"label": "Booked", "value": booked.toString()},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned.fill(
        //   child: Animatedgradientpage(),
        // ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3), // Semi-transparent container
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: const Offset(0, 5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Leads Statistics',
                    style: TextStyle(
                      color: Color(0xFF042630),
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: _funnelData.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {},
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Wrap the Row in a SingleChildScrollView for horizontal scrolling
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _funnelData[_selectedFilter]!.map((data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: FunnelStage(
                        label: data["label"]!,
                        value: data["value"]!,
                        onTap: () {},
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FunnelStage extends StatelessWidget {
  final String label;
  final String value;

  const FunnelStage({
    super.key,
    required this.label,
    required this.value,
    required Null Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the content vertically
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF042630),
            ),
          ),
          const SizedBox(height: 8),
          FunnelSegment(value: double.parse(value)), // Pass the value directly
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF042630),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FunnelSegment extends StatelessWidget {
  final double value; // Changed from percentage to value

  const FunnelSegment({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0), // Add left padding here
      child: Container(
        width: 60, // Fixed width for all segments
        height: value, // Adjust height based on value
        margin: const EdgeInsets.only(top: 4.0), // Optional: margin on top
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF005254),
              Color(0xFF042630),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0), // Set top radius here
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          value.toString(), // Display the value
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
