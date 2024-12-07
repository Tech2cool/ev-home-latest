import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/graph/doughnut_chart.dart';
import 'package:ev_homes/components/graph/funnel_chart.dart';
import 'package:ev_homes/components/graph/line_chart.dart';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/pages/admin_pages/inventory_page1.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_marina_bay.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter_9_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule%20_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule_marina_bay.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/update_payment_schedule_9_squre.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/update_status_10%20marina_bay.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';

class PostSaleHeadDashboard extends StatefulWidget {
  final String? id;
  const PostSaleHeadDashboard({super.key, this.id});

  @override
  State<PostSaleHeadDashboard> createState() => _PostSaleHeadDashboardState();
}

class _PostSaleHeadDashboardState extends State<PostSaleHeadDashboard> {
  bool showNotification = false;
  double notificationHeight = 0;
  bool isLoading = false;
  OurProject? selectedProject;

  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    try {
      setState(() {
        isLoading = true;
      });
      await settingProvider.getPostSaleLead();
      await settingProvider.getOurProject();
      await settingProvider.getDesignation();
      await settingProvider.getDivision();
      await settingProvider.getDepartment();
    } catch (e) {
      //
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  List<PostSaleLead> getFilteredLeads(List<PostSaleLead> leads, String status) {
    if (status == "Total") return leads;
    return leads.where((lead) => lead.bookingStatus?.type == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final leadsPostSale = settingProvider.leadsPostSale;
    final leads = leadsPostSale.data;
    return Stack(
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
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<OurProject>(
                    value: selectedProject,
                    hint: Text(
                      "Select Project",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    items: settingProvider.ourProject.map((OurProject project) {
                      return DropdownMenuItem<OurProject>(
                        value: project,
                        child: Text(
                          project.name ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
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
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 248, 85, 4),
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 248, 85, 4),
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push(
                                // "/post-sale-head-lead-list/Total",
                                "/post-sales-executive-lead-list/Total/${widget.id ?? settingProvider.loggedAdmin!.id!}");
                          },
                          child: SizedBox(
                            height: 80,
                            width: 100,
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
                                // "/post-sale-head-lead-list/Registration Done",
                                "/post-sales-executive-lead-list/Registration Done/${widget.id ?? settingProvider.loggedAdmin!.id!}");
                          },
                          child: SizedBox(
                            height: 80,
                            width: 100,
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
                                "/post-sales-executive-lead-list/EOI Received/${widget.id ?? settingProvider.loggedAdmin!.id!}");
                          },
                          child: SizedBox(
                            height: 80,
                            width: 100,
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
                                // "/post-sale-head-lead-list/Cancelled",
                                "/post-sales-executive-lead-list/Cancelled/${widget.id ?? settingProvider.loggedAdmin!.id!}");
                          },
                          child: SizedBox(
                            height: 80,
                            width: 100,
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
                ElevatedButton(
                  onPressed: () {
                    if (selectedProject == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a project first'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (selectedProject!.name!
                        .toLowerCase()
                        .contains("marina")) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UpdateStatus10(),
                      ));
                    } else if (selectedProject!.name!
                        .toLowerCase()
                        .contains("square")) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UpdatePayment9(),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'View Project Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InventoryPage1(onButtonPressed: (view) {})));
                    },
                    icon: const Icon(
                      FluentIcons.box_24_regular,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Inventory",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                LineChart(
                  title: "Booking Over Month",
                  chartData: leadsOverMonths,
                ),
                DoughnutChart(
                  title: "Booking Report",
                  chartData: presalesData,
                  onPressFilter: (val) {},
                ),
                DoughnutChart(
                  title: "Excecutive Report",
                  chartData: dailyreport,
                  centerValue: "100",
                  onPressFilter: (val) {},
                ),
                FunnelChart(
                  title: "Booking Funnel",
                  initialFunnelData: initialFunnelData,
                  onPressFilter: (val) {},
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (selectedProject == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please select a project first'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else if (selectedProject!.name!
                                    .toLowerCase()
                                    .contains("marina")) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const CostGenerator(),
                                  ));
                                } else if (selectedProject!.name!
                                    .toLowerCase()
                                    .contains("square")) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CostGenerators(),
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                'Cost Sheet Generator',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (selectedProject == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please select a project first'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else if (selectedProject!.name!
                                    .toLowerCase()
                                    .contains("marina")) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentScheduleGenerator(),
                                  ));
                                } else if (selectedProject!.name!
                                    .toLowerCase()
                                    .contains("square")) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentScheduleGenerators(),
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amberAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                'Payment Schedule',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedProject == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a project first'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (selectedProject!.name!
                              .toLowerCase()
                              .contains("marina")) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const DemandLetter10(),
                            ));
                          } else if (selectedProject!.name!
                              .toLowerCase()
                              .contains("square")) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const DemandLetter(),
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Demand Letter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ),
        ),
        if (isLoading) const LoadingSquare()
      ],
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
        color: bgColor ?? Colors.white.withOpacity(0.8),
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
