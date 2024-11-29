// lib/dashboard_page.dart

import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/graph/funnel_chart.dart';
import 'package:ev_homes/components/graph/line_chart.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PreSalesExecutiveDashboard extends StatefulWidget {
  final String? id;

  const PreSalesExecutiveDashboard({super.key, this.id});

  @override
  State<PreSalesExecutiveDashboard> createState() =>
      _PreSalesExecutiveDashboardState();
}

class _PreSalesExecutiveDashboardState
    extends State<PreSalesExecutiveDashboard> {
  bool showNotification = false;
  double notificationHeight = 0;
  bool isLoading = false;

  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    await settingProvider.getPreSalesExecutiveLeads(
      widget.id ?? settingProvider.loggedAdmin!.id!,
    );
    await Future.delayed(const Duration(seconds: 2));
  }

  List<ChartModel> generateLineChart(List<Lead> leads) {
    Map<String, int> leadCountMap = {};
    for (Lead lead in leads) {
      if (lead.preSalesExecutive != null) {
        String monthYear =
            "${Helper.getShortMonthName(lead.startDate.toString())} ${lead.startDate.year}";

        // Increment the count for this month-year
        leadCountMap.update(monthYear, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    return leadCountMap.entries.map((entry) {
      return ChartModel(category: entry.key, value: entry.value.toDouble());
    }).toList();
  }

  List<ChartModel> generateLeadStatusFunnel(List<Lead> preSalesExecutive) {
    Map<String, int> leadCountMap = {};
    for (Lead lead in preSalesExecutive) {
      String preSalesExecutiveName = lead.status ?? "";
      leadCountMap.update(
        preSalesExecutiveName,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    return leadCountMap.entries.map((entry) {
      return ChartModel(category: entry.key, value: entry.value.toDouble());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final leads = settingProvider.leadsPreSaleExecutive;
    final List<ChartModel> lineChartData = generateLineChart(leads.data);
    final List<ChartModel> leadStatusFunnelData =
        generateLeadStatusFunnel(leads.data);

    // Filtered leads by status
    final contactedLeads =
        leads.data.where((lead) => lead.status == "Contacted").toList();
    final followupLeads =
        leads.data.where((lead) => lead.status == "Followup").toList();
    final pendingLeads =
        leads.data.where((lead) => lead.status == "Pending").toList();
    final totalLeads = leads.data.length;

    return SafeArea(
      child: Stack(
        children: [
          const Positioned.fill(
            child: AnimatedGradientBg(),
          ),
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
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push(
                                  "/pre-sales-executive-lead-list/Total/${widget.id ?? settingProvider.loggedAdmin!.id!}");
                            },
                            child: MyCard(
                              label: "Total",
                              value: totalLeads,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push(
                                  "/pre-sales-executive-lead-list/Contacted/${widget.id ?? settingProvider.loggedAdmin!.id!}");
                            },
                            child: MyCard(
                              textColor: Colors.green,
                              label: "Contacted",
                              value: contactedLeads.length,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push(
                                  "/pre-sales-executive-lead-list/Followup/${widget.id ?? settingProvider.loggedAdmin!.id!}");
                            },
                            child: MyCard(
                              textColor: Colors.red,
                              label: "Followup",
                              value: followupLeads.length,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push(
                                  "/pre-sales-executive-lead-list/Pending/${widget.id ?? settingProvider.loggedAdmin!.id!}");
                            },
                            child: MyCard(
                              textColor: Colors.yellow.shade700,
                              label: "Pending",
                              value: pendingLeads.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  LineChart(
                    title: "Leads Over Months",
                    chartData: lineChartData,
                  ),
                  // DoughnutChart(
                  //   title: "Call Report",
                  //   chartData: channelPartnerData,
                  //   centerValue: "100",
                  //   onPressFilter: (filter) {},
                  // ),
                  FunnelChart(
                    title: "Leads Funnel",
                    initialFunnelData: leadStatusFunnelData,
                    onPressFilter: (filter) {},
                  ),
                  const SizedBox(height: 20),

                  // New section: Display Contacted Leads
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Contacted Leads',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: contactedLeads.length,
                    itemBuilder: (context, index) {
                      final lead = contactedLeads[index];
                      return ListTile(
                        title: Text(lead.channelPartner?.firstName ?? "NA"),
                        subtitle: Text('Status: ${lead.status}'),
                        trailing: Text('Date: ${lead.startDate}'),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final String label;
  final int value;
  final double? width;
  final Color? textColor;
  final Color? bgColor;
  final List<BoxShadow>? boxShadow;

  const MyCard({
    super.key,
    required this.label,
    required this.value,
    this.textColor,
    this.bgColor,
    this.width,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: bgColor ??
            Colors.white.withOpacity(
                0.8), // Slight opacity for better background visibility
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.grey.withAlpha(50).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
