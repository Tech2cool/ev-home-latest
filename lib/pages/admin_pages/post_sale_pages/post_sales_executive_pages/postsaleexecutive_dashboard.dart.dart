import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/graph/doughnut_chart.dart';
import 'package:ev_homes/components/graph/funnel_chart.dart';
import 'package:ev_homes/components/graph/line_chart.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostsaleexcecutiveDashboard extends StatefulWidget {
  final String? id;
  const PostsaleexcecutiveDashboard({super.key, this.id});

  @override
  State<PostsaleexcecutiveDashboard> createState() =>
      _PostsaleexcecutiveDashboardState();
}

class _PostsaleexcecutiveDashboardState
    extends State<PostsaleexcecutiveDashboard> {
  bool showNotification = false;
  double notificationHeight = 0;
  bool isLoading = false;
  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    await settingProvider.getPostSalesExecutiveLeads(
      widget.id ?? settingProvider.loggedAdmin!.id!,
    );
    await Future.delayed(const Duration(seconds: 2));
  }

  List<String> projects = ["10 Marina", "9 Square"];
  String? selectedProject;

  // Dummy Filters
  final List<FilterData> filters = [
    FilterData("Date", Icons.calendar_month),
    // Add more filters if needed
  ];

  // Generates chart data for the line chart
  // List<ChartModel> generateChartData() {
  //   return leads.map((lead) {
  //     return ChartModel(
  //       category: Helper.getShortMonthName(lead.startDate),
  //       value: 10,
  //     );
  //   }).toList();
  // }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);

    final leadsPostSale = settingProvider.leadsPostSaleExecutive;
    final leads = leadsPostSale.data;
// Dummy Chart Data
    final List<ChartModel> presalesData = [
      ChartModel(category: 'Register', value: 30),
      ChartModel(category: 'EOI Received', value: 40),
      ChartModel(category: 'Cancelled', value: 30),
    ];

    final List<ChartModel> dailyreport = [
      ChartModel(category: 'Mona', value: 40),
      ChartModel(category: 'Anju', value: 10),
    ];

    final List<ChartModel> leadsOverMonths = [
      ChartModel(category: 'Jan', value: 30),
      ChartModel(category: 'Feb', value: 28),
      ChartModel(category: 'Mar', value: 34),
      ChartModel(category: 'Apr', value: 32),
      ChartModel(category: 'May', value: 40),
    ];

    // Dummy Funnel Data
    final List<ChartModel> initialFunnelData = [
      ChartModel(category: 'Disbursment', value: 20),
      ChartModel(category: 'Registration Done', value: 15),
      ChartModel(category: 'Bookings', value: 10),
      ChartModel(category: 'EOI', value: 40),
    ];

    // final preSaleExecutives = settingProvider.preSaleExecutives;
    // final assignedLeads =
    //     leads.where((ele) => ele.preSalesExecutive != null).toList();
    // final pendingAssignLeads =
    //     leads.where((ele) => ele.preSalesExecutive == null).toList();

    // final List<ChartData> lineChartData = generateLineChart(leads);
    // final List<ChartData> teamLeaderData = generateTeamLeaderChart(leads);
    // final List<ChartData> cpLeadData = generateChannelPartnerChart(leads);
    // final List<FunnelData> leadStatusFunnelData =
    //     generateLeadStatusFunnel(leads);

    final List<ChartModel> lineChartData = [];

    return SafeArea(
      child: Stack(
        children: [
          // Background Image
          const Positioned.fill(
            child: AnimatedGradientBg(),
          ),
          // Main Content
          Scaffold(
            backgroundColor: Colors
                .transparent, // Make Scaffold transparent to show background
            appBar: AppBar(
              title: const Text("Dashboard"),
              backgroundColor:
                  Colors.transparent, // Make AppBar transparent if needed
              elevation: 0, // Remove AppBar shadow
            ),
            body: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: [
                  // Dropdown for Project Selection
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedProject,
                      hint: Text(
                        "Select Project",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16), // Customized hint style
                      ),
                      items: projects.map((project) {
                        return DropdownMenuItem<String>(
                          value: project,
                          child: Text(
                            project,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ), // Customize item text style
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProject = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none, // Remove default border
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 248, 85, 4),
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 248, 85, 4)),
                      dropdownColor: Colors.white,
                    ),
                  ),

                  // Cards Section
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push(
                                "/post-sales-executive-lead-list/Total/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                              );
                            },
                            child: SizedBox(
                              height: 80,
                              width: 100, // Set a fixed width
                              child: MyCard(
                                label: "Total Booking",
                                value: leadsPostSale.totalItems,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push(
                                "/post-sales-executive-lead-list/Registration Done/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                              );
                            },
                            child: SizedBox(
                              height: 80,
                              width: 100, // Set a fixed width
                              child: MyCard(
                                textColor: Colors.green,
                                label: "Registration Done",
                                value: leadsPostSale.registrationDone,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push(
                                "/post-sales-executive-lead-list/EOI Received/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                              );
                            },
                            child: SizedBox(
                              height: 80,
                              width: 100, // Set a fixed width
                              child: MyCard(
                                textColor: Colors.orange,
                                label: "EOI Received",
                                value: leadsPostSale.eoiRecieved,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push(
                                "/post-sales-executive-lead-list/Cancelled/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                              );
                            },
                            child: SizedBox(
                              height: 80,
                              width: 100, // Set a fixed width
                              child: MyCard(
                                textColor: Colors.red.shade700,
                                label: "Cancelled",
                                value: leadsPostSale.cancelled,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Line Chart with Blurred Background
                  LineChart(
                    title: "Booking Over Month",
                    chartData: leadsOverMonths,
                  ),
                  // Doughnut Charts
                  DoughnutChart(
                    title: "Booking Report",
                    chartData: presalesData,
                    onPressFilter: (filter) {},
                  ),

                  FunnelChart(
                    title: "Booking Funnel",
                    initialFunnelData: initialFunnelData,
                    onPressFilter: (filter) {},
                  ),
                  const SizedBox(height: 80),
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
          // Notification Icon and Panel
          Positioned(
            top: 15,
            right: 15,
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (showNotification) {
                        notificationHeight = 0;
                      } else {
                        notificationHeight = 200;
                      }
                      showNotification = !showNotification;
                    });
                  },
                  icon: const Icon(Icons.notifications),
                ),
                if (leads.isNotEmpty)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 16,
                      height: 16,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Text(
                          "${leads.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Notification Panel
          if (showNotification)
            Positioned(
              top: 60,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 660),
                width: 200,
                height: notificationHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  children: [
                    ...leads.map((lead) {
                      return ListTile(
                        leading: const Icon(
                          Icons.notifications_active,
                          color: Colors.red,
                        ),
                        title: Text(
                          "New lead from ${lead.firstName} ${lead.lastName}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 2,
                        ),
                        subtitle: Text(
                          Helper.formatDate(lead.date.toString()),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      );
                    }),
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
        horizontal: 5,
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
            textAlign: TextAlign.center,
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
