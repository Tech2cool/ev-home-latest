import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/graph/doughnut_chart.dart';
import 'package:ev_homes/components/graph/funnel_chart.dart';
import 'package:ev_homes/components/graph/line_chart.dart';
import 'package:ev_homes/components/my_card.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DataAnalyzerDashboard extends StatefulWidget {
  final String? id;
  const DataAnalyzerDashboard({super.key, this.id});

  @override
  State<DataAnalyzerDashboard> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DataAnalyzerDashboard> {
  bool showNotification = false;
  double notificationHeight = 0;
  bool isLoading = false;

  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    // if (settingProvider.searchLeads.data.isNotEmpty) return;
    setState(() {
      isLoading = true;
    });
    try {
      await settingProvider.searchLead();
      await settingProvider.leadForGraph();
      await settingProvider.leadsTeamLeaderGraphForDt();
      await settingProvider.getLeadsFunnelGraph();
      await settingProvider.getleadsChannelPartnerGraph();
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
    super.initState();
    _onRefresh();
  }

  void onPressFilter(String filter) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    await settingProvider.leadsTeamLeaderGraphForDt(filter.toLowerCase());
  }

  void onPressFilterFunnel(String filter) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    await settingProvider.getLeadsFunnelGraph(filter.toLowerCase());
  }

  void onPressFilterChannelPartnerGraph(String filter) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    await settingProvider.getleadsChannelPartnerGraph(filter.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final searchLeads = settingProvider.searchLeads;
    final lineChartData = settingProvider.leadsMonthly;
    final teamLeaderData = settingProvider.leadsTeamLeaderGraphForDT;
    final leadStatusFunnelData = settingProvider.leadsFunnelGraph;
    final cpLeadData = settingProvider.leadsChannelPartnerGraph;

    return Stack(
      children: [
        // Background Image
        const Positioned.fill(
          child: AnimatedGradientBg(),
        ),
        // Main Content
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Dashboard"),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              children: [
                Column(
                  children: [
                    // Cards Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                GoRouter.of(context).push(
                                  "/data-analyzer-lead-list/Total",
                                );
                              },
                              child: MyCard(
                                label: "Total",
                                value: searchLeads.totalItems,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                GoRouter.of(context).push(
                                  "/data-analyzer-lead-list/Approved",
                                );
                              },
                              child: MyCard(
                                textColor: Colors.green,
                                label: "Approved",
                                value: searchLeads.approvedCount,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                GoRouter.of(context).push(
                                  "/data-analyzer-lead-list/Rejected",
                                );
                              },
                              child: MyCard(
                                textColor: Colors.red,
                                label: "Rejected",
                                value: searchLeads.rejectedCount,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                GoRouter.of(context).push(
                                  "/data-analyzer-lead-list/Pending",
                                );
                              },
                              child: MyCard(
                                textColor: Colors.yellow.shade700,
                                label: "Pending",
                                value: searchLeads.pendingCount,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Line Chart with Blurred Background
                    SizedBox(
                      width: double.infinity,
                      child: LineChart(
                        title: "Leads Over Months",
                        chartData: lineChartData,
                      ),
                    ),
                    DoughnutChart(
                      title: "Team Leader Report",
                      chartData: teamLeaderData,
                      onPressFilter: onPressFilter,
                    ),
                    DoughnutChart(
                      title: "Channel Partner Report",
                      chartData: cpLeadData,
                      onPressFilter: onPressFilterChannelPartnerGraph,
                    ),
                    // Funnel Chart
                    FunnelChart(
                      title: "Leads Funnel",
                      initialFunnelData: leadStatusFunnelData,
                      onPressFilter: onPressFilterFunnel,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Notification Overlay
        if (showNotification)
          GestureDetector(
            onTap: () {
              setState(() {
                notificationHeight = 0;
                showNotification = false;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.05),
            ),
          ),

        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
