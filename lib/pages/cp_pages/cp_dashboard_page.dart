import 'package:dio/dio.dart';
import 'package:ev_homes/components/cp_videoplayer.dart';
import 'package:ev_homes/components/graph/doughnut_chart.dart';
import 'package:ev_homes/components/graph/funnel_chart.dart';
import 'package:ev_homes/components/graph/line_chart.dart';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/models/tagging_form_model.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:ev_homes/pages/cp_pages/client_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class DashboardScreen extends StatefulWidget {
  final Lead? lead;
  const DashboardScreen({this.lead, super.key});

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
      await settingProvider.searchLeadChannelPartner(
        settingProvider.loggedChannelPartner!.id!,
      );
      await settingProvider.getleadsChannelPartnerGraphById(
          settingProvider.loggedChannelPartner!.id!);
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
    final graph = settingProvider.leadsChannelPartnerGraph;
    print(cpLeads);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 157, 211, 221),
            title: const Text(
              'Dashboard',
              style: TextStyle(
                color: Color(0xFF042630),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: Stack(
              children: [
                CpVideoplayer(),
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
                                      builder: (context) => const ClientReport(
                                          selectedFilter: 'All'),
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
                                        selectedFilter: 'Pending',
                                      ),
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
                        SizedBox(
                          width: double.infinity,
                          child: LineChart(chartData: graph),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: DoughnutChart(
                            title: "",
                            pallets: [
                              Colors.green,
                              Colors.red,
                              const Color.fromARGB(255, 250, 219, 125)
                            ],
                            chartData: [
                              ChartModel(
                                category: "Approved",
                                value: cpLeads.approvedCount.toDouble(),
                              ),
                              ChartModel(
                                category: "Rejected",
                                value: cpLeads.rejectedCount.toDouble(),
                              ),
                              ChartModel(
                                category: "In Progress",
                                value: cpLeads.pendingCount.toDouble(),
                              ),
                            ],
                            onPressFilter: (f) {},
                          ),
                        ),

                        // const SizedBox(height: 20),
                        // const PieChartDemo(), // Dummy data for charts
                        // const SizedBox(height: 20),
                        FunnelChart(initialFunnelData: [
                          ChartModel(
                            category: "Visit",
                            value: cpLeads.visitCount.toDouble(),
                          ),
                          ChartModel(
                            category: "Revisit",
                            value: cpLeads.revisitCount.toDouble(),
                          ),
                          ChartModel(
                            category: "In Progress",
                            value: cpLeads.pendingCount.toDouble(),
                          ),
                          ChartModel(
                            category: "Booking",
                            value: cpLeads.bookingCount.toDouble(),
                          ),
                        ], onPressFilter: (N) {}),
                        const SizedBox(height: 180),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading) LoadingSquare()
      ],
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

class FunnelChartDemo extends StatefulWidget {
  final Lead? lead;

  const FunnelChartDemo({super.key, this.lead});

  @override
  State<FunnelChartDemo> createState() => _FunnelChartDemoState();
}

class _FunnelChartDemoState extends State<FunnelChartDemo> {
  final String _selectedFilter = "Last Week";
  late Map<String, List<Map<String, String>>> _funnelData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // _funnelData = _generateFunnelData();
  }

  Future<void> fetchLead() async {}

  // Map<String, List<Map<String, String>>> _generateFunnelData() {
  //   return {
  //     "Last Week": _getFunnelDataForPeriod(
  //         DateTime.now().subtract(const Duration(days: 7))),
  //     "Last Month": _getFunnelDataForPeriod(
  //         DateTime.now().subtract(const Duration(days: 30))),
  //     "Last Year": _getFunnelDataForPeriod(
  //         DateTime.now().subtract(const Duration(days: 365))),
  //   };
  // }

  // List<Map<String, String>> _getFunnelDataForPeriod(DateTime startDate) {
  //   int noresponse = 22;
  //   int notInterested = 33;
  //   int pipelined = 30;
  //   int siteVisited = 10;
  //   int booked = 40;
  //   int total = noresponse + notInterested + pipelined + siteVisited + booked;

  // for (var lead in widget.leads) {
  //   DateTime leadDate = DateTime.parse(lead.startDate);

  // if (leadDate.isAfter(startDate)) {
  //   total++;
  //   if (lead.taggingStatus == 'NoResponse') noresponse++;
  //   if (lead.taggingStatus == 'NotInterested') notInterested++;
  //   if (lead.taggingStatus == 'Pipelined') pipelined++;
  //   if (lead.taggingStatus == 'Site visited') siteVisited++;
  //   if (lead.taggingStatus == 'Booked') booked++;
  // }
  // }

  //   return [
  //     {"label": "Total", "value": total.toString()},
  //     {"label": "NoResponse", "value": noresponse.toString()},
  //     {"label": "NotInterested", "value": notInterested.toString()},
  //     {"label": "Pipelined", "value": pipelined.toString()},
  //     {"label": "Site visited", "value": siteVisited.toString()},
  //     {"label": "Booked", "value": booked.toString()},
  //   ];
  // }

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
