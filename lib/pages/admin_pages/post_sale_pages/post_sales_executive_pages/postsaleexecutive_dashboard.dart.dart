import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/graph/doughnut_chart.dart';
import 'package:ev_homes/components/graph/funnel_chart.dart';
import 'package:ev_homes/components/graph/line_chart.dart';
import 'package:ev_homes/components/my_transculent_box.dart';
import 'package:ev_homes/core/models/chart_model.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/inventory_page1.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/closing_manager_pages/task_list_page.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_marina_bay.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter_9_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule%20_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule_marina_bay.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/update_payment_schedule_9_squre.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/update_status_10%20marina_bay.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/models/post_sale_lead.dart';

class PostsaleexecutiveDashboard extends StatefulWidget {
  final String? id;
  const PostsaleexecutiveDashboard({super.key, this.id});

  @override
  State<PostsaleexecutiveDashboard> createState() =>
      _PostsaleexecutiveDashboardState();
}

class _PostsaleexecutiveDashboardState
    extends State<PostsaleexecutiveDashboard> {
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
      await settingProvider.getPostSalesExecutiveLeads(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
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

  Future<void> _showProjectDialogForCostSheet() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    OurProject? selectedProject;
    // print(settingProvider.ourProject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project'),
          content: DropdownButtonFormField<OurProject>(
            value: projects.contains(selectedProject) ? selectedProject : null,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            items: projects.map((project) {
              return DropdownMenuItem<OurProject>(
                value: project,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProject = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a Project';
              }
              return null;
            },
            isExpanded: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProject!.name!.toLowerCase().contains("square")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CostGenerators(),
                    ),
                  );
                }
                if (selectedProject!.name!.toLowerCase().contains("marina")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CostGenerator(),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
    // print(selectedProject);
  }

  Future<void> _showProjectDialogForPaymentSchedule() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    OurProject? selectedProject;
    // print(settingProvider.ourProject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project'),
          content: DropdownButtonFormField<OurProject>(
            value: projects.contains(selectedProject) ? selectedProject : null,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            items: projects.map((project) {
              return DropdownMenuItem<OurProject>(
                value: project,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProject = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a Project';
              }
              return null;
            },
            isExpanded: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProject!.name!.toLowerCase().contains("square")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentScheduleGenerators(),
                    ),
                  );
                }
                if (selectedProject!.name!.toLowerCase().contains("marina")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentScheduleGenerator(),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
    // print(selectedProject);
  }

  Future<void> _showProjectDialogForDemand() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final projects = settingProvider.ourProject;
    OurProject? selectedProject;
    // print(settingProvider.ourProject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Project'),
          content: DropdownButtonFormField<OurProject>(
            value: projects.contains(selectedProject) ? selectedProject : null,
            decoration: InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            items: projects.map((project) {
              return DropdownMenuItem<OurProject>(
                value: project,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProject = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a Project';
              }
              return null;
            },
            isExpanded: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProject!.name!.toLowerCase().contains("square")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DemandLetter(),
                    ),
                  );
                }
                if (selectedProject!.name!.toLowerCase().contains("marina")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DemandLetter10(),
                    ),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
    // print(selectedProject);
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  // List<PostSaleLead> getFilteredLeads(List<PostSaleLead> leads, String status) {
  //   if (status == "Total") return leads;
  //   return leads.where((lead) => lead.bookingStatus?.type == status).toList();
  // }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final leadsPostSale = settingProvider.leadsPostSaleExecutive;
    final leads = leadsPostSale.data;

    final tasks = settingProvider.tasks;
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
                              "/post-sales-executive-lead-list/Total/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
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
                              "/post-sales-executive-lead-list/Registration Done/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
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
                              "/post-sales-executive-lead-list/EOI Received/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
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
                              "/post-sales-executive-lead-list/Cancelled/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
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

                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      Stack(
                        children: [
                          MyTransculentBox(
                            icon: FluentIcons.tasks_app_20_regular,
                            iconColor: Colors.pink,
                            text: "My Task",
                            textColor: Colors.white,
                            onTap: () => _showTaskDialog(context),
                          ),
                          Positioned(
                            right: 30,
                            top: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Bubble for pending count
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      tasks
                                          .where(
                                              (ele) => ele.completed == false)
                                          .length
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      MyTransculentBox(
                        icon: FluentIcons.task_list_square_ltr_24_regular,
                        iconColor: Colors.pink,
                        text: "Follow Up Status",
                        textColor: Colors.white,
                        onTap: () {
                          GoRouter.of(context).push(
                            "/closing-manager-follow-up-list/followup/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                          );
                        },
                      ),
                      MyTransculentBox(
                        icon: FluentIcons.box_24_regular,
                        iconColor: Colors.pink,
                        text: "Inventory",
                        textColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InventoryPage1(
                                onButtonPressed: (view) {},
                              ),
                            ),
                          );
                        },
                      ),
                      MyTransculentBox(
                        icon: FluentIcons.receipt_16_regular,
                        iconColor: Colors.pink,
                        text: "Cost Sheet",
                        textColor: Colors.white,
                        onTap: () => _showProjectDialogForCostSheet(),
                      ),
                      MyTransculentBox(
                        icon: FluentIcons.calendar_clock_16_regular,
                        iconColor: Colors.pink,
                        text: "Payment Schedule",
                        textColor: Colors.white,
                        onTap: () => _showProjectDialogForPaymentSchedule(),
                      ),
                      MyTransculentBox(
                        icon: FluentIcons.document_text_16_regular,
                        iconColor: Colors.pink,
                        text: "Demand Letter",
                        textColor: Colors.white,
                        onTap: () => _showProjectDialogForDemand(),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 16.0,
                //     vertical: 12.0,
                //   ),
                //   child: Row(
                //     children: [
                //       const SizedBox(width: 16),
                //       Expanded(
                //         child: ElevatedButton.icon(
                //           onPressed: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => InventoryPage1(
                //                         onButtonPressed: (view) {})));
                //           },
                //           icon: const Icon(
                //             FluentIcons.box_24_regular,
                //             color: Colors.white,
                //           ),
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.blue,
                //             padding: const EdgeInsets.symmetric(vertical: 10.0),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(12.0),
                //             ),
                //           ),
                //           label: const Text(
                //             'Inventory',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),

                const SizedBox(
                  height: 10,
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
                // Padding(
                //   padding: const EdgeInsets.all(5),
                //   child: Column(
                //     children: [
                //       Row(
                //         children: [
                //           Expanded(
                //             child: ElevatedButton(
                //               onPressed: () {
                //                 if (selectedProject == null) {
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     const SnackBar(
                //                       content:
                //                           Text('Please select a project first'),
                //                       backgroundColor: Colors.red,
                //                     ),
                //                   );
                //                 } else if (selectedProject!.name!
                //                     .toLowerCase()
                //                     .contains("marina")) {
                //                   Navigator.of(context).push(MaterialPageRoute(
                //                     builder: (context) => const CostGenerator(),
                //                   ));
                //                 } else if (selectedProject!.name!
                //                     .toLowerCase()
                //                     .contains("square")) {
                //                   Navigator.of(context).push(MaterialPageRoute(
                //                     builder: (context) =>
                //                         const CostGenerators(),
                //                   ));
                //                 }
                //               },
                //               style: ElevatedButton.styleFrom(
                //                 backgroundColor: Colors.white,
                //                 padding:
                //                     const EdgeInsets.symmetric(vertical: 10.0),
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(12.0),
                //                 ),
                //               ),
                //               child: const Text(
                //                 'Cost Sheet Generator',
                //                 style: TextStyle(
                //                   color: Colors.black,
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //           ),
                //           const SizedBox(width: 16),
                //           Expanded(
                //             child: ElevatedButton(
                //               onPressed: () {
                //                 if (selectedProject == null) {
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     const SnackBar(
                //                       content:
                //                           Text('Please select a project first'),
                //                       backgroundColor: Colors.red,
                //                     ),
                //                   );
                //                 } else if (selectedProject!.name!
                //                     .toLowerCase()
                //                     .contains("marina")) {
                //                   Navigator.of(context).push(MaterialPageRoute(
                //                     builder: (context) =>
                //                         PaymentScheduleGenerator(),
                //                   ));
                //                 } else if (selectedProject!.name!
                //                     .toLowerCase()
                //                     .contains("square")) {
                //                   Navigator.of(context).push(MaterialPageRoute(
                //                     builder: (context) =>
                //                         const PaymentScheduleGenerators(),
                //                   ));
                //                 }
                //               },
                //               style: ElevatedButton.styleFrom(
                //                 backgroundColor: Colors.amberAccent,
                //                 padding:
                //                     const EdgeInsets.symmetric(vertical: 10.0),
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(12.0),
                //                 ),
                //               ),
                //               child: const Text(
                //                 'Payment Schedule',
                //                 style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 16),
                //       ElevatedButton(
                //         onPressed: () {
                //           if (selectedProject == null) {
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               const SnackBar(
                //                 content: Text('Please select a project first'),
                //                 backgroundColor: Colors.red,
                //               ),
                //             );
                //           } else if (selectedProject!.name!
                //               .toLowerCase()
                //               .contains("marina")) {
                //             Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => const DemandLetter10(),
                //             ));
                //           } else if (selectedProject!.name!
                //               .toLowerCase()
                //               .contains("square")) {
                //             Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => const DemandLetter(),
                //             ));
                //           }
                //         },
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.amberAccent,
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 30.0, vertical: 10.0),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12.0),
                //           ),
                //         ),
                //         child: const Text(
                //           'Demand Letter',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 16,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //       const SizedBox(height: 16),
                //     ],
                //   ),
                // ),
                const SizedBox(width: 80),
              ],
            ),
          ),
        ),
        if (isLoading) const LoadingSquare()
      ],
    );
  }

  void _showTaskDialog(
    BuildContext context,
  ) {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    final tasks = settingProvider.tasks;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 300, // Dialog height
            width: 200, // Dialog width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tasks",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green),
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    tasks
                                        .where((ele) =>
                                            ele.type == "first-call" &&
                                            ele.completed == false)
                                        .length
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: const Text("First Call"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskListPage(
                                  id: widget.id,
                                  type: "first-call",
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.task_alt, color: Colors.blue),
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    tasks
                                        .where((ele) =>
                                            ele.type == "follow-up" &&
                                            ele.completed == false)
                                        .length
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: const Text("Follow-Up Call"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskListPage(
                                  id: widget.id,
                                  type: "follow-up",
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.note, color: Colors.orange),
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    tasks
                                        .where((ele) =>
                                            ele.type == "schedule-meeting" &&
                                            ele.completed == false)
                                        .length
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: const Text("Schedule Meeting"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskListPage(
                                  id: widget.id,
                                  type: "schedule-meeting",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

// import 'package:ev_homes/components/animated_gradient_bg.dart';
// import 'package:ev_homes/components/graph/doughnut_chart.dart';
// import 'package:ev_homes/components/graph/funnel_chart.dart';
// import 'package:ev_homes/components/graph/line_chart.dart';
// import 'package:ev_homes/core/helper/helper.dart';
// import 'package:ev_homes/core/models/chart_model.dart';
// import 'package:ev_homes/core/providers/setting_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// class PostsaleexcecutiveDashboard extends StatefulWidget {
//   final String? id;
//   const PostsaleexcecutiveDashboard({super.key, this.id});

//   @override
//   State<PostsaleexcecutiveDashboard> createState() =>
//       _PostsaleexcecutiveDashboardState();
// }

// class _PostsaleexcecutiveDashboardState
//     extends State<PostsaleexcecutiveDashboard> {
//   bool showNotification = false;
//   double notificationHeight = 0;
//   bool isLoading = false;
//   Future<void> _onRefresh() async {
//     final settingProvider = Provider.of<SettingProvider>(
//       context,
//       listen: false,
//     );
//     await settingProvider.getPostSalesExecutiveLeads(
//       widget.id ?? settingProvider.loggedAdmin!.id!,
//     );
//     await Future.delayed(const Duration(seconds: 2));
//   }

//   List<String> projects = ["10 Marina", "9 Square"];
//   String? selectedProject;

//   // Dummy Filters
//   final List<FilterData> filters = [
//     FilterData("Date", Icons.calendar_month),
//     // Add more filters if needed
//   ];

//   // Generates chart data for the line chart
//   // List<ChartModel> generateChartData() {
//   //   return leads.map((lead) {
//   //     return ChartModel(
//   //       category: Helper.getShortMonthName(lead.startDate),
//   //       value: 10,
//   //     );
//   //   }).toList();
//   // }

//   @override
//   void initState() {
//     super.initState();
//     _onRefresh();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final settingProvider = Provider.of<SettingProvider>(context);

//     final leadsPostSale = settingProvider.leadsPostSaleExecutive;
//     final leads = leadsPostSale.data;
// // Dummy Chart Data
//     final List<ChartModel> presalesData = [
//       ChartModel(category: 'Register', value: 30),
//       ChartModel(category: 'EOI Received', value: 40),
//       ChartModel(category: 'Cancelled', value: 30),
//     ];

//     final List<ChartModel> dailyreport = [
//       ChartModel(category: 'Mona', value: 40),
//       ChartModel(category: 'Anju', value: 10),
//     ];

//     final List<ChartModel> leadsOverMonths = [
//       ChartModel(category: 'Jan', value: 30),
//       ChartModel(category: 'Feb', value: 28),
//       ChartModel(category: 'Mar', value: 34),
//       ChartModel(category: 'Apr', value: 32),
//       ChartModel(category: 'May', value: 40),
//     ];

//     // Dummy Funnel Data
//     final List<ChartModel> initialFunnelData = [
//       ChartModel(category: 'Disbursment', value: 20),
//       ChartModel(category: 'Registration Done', value: 15),
//       ChartModel(category: 'Bookings', value: 10),
//       ChartModel(category: 'EOI', value: 40),
//     ];

//     // final preSaleExecutives = settingProvider.preSaleExecutives;
//     // final assignedLeads =
//     //     leads.where((ele) => ele.preSalesExecutive != null).toList();
//     // final pendingAssignLeads =
//     //     leads.where((ele) => ele.preSalesExecutive == null).toList();

//     // final List<ChartData> lineChartData = generateLineChart(leads);
//     // final List<ChartData> teamLeaderData = generateTeamLeaderChart(leads);
//     // final List<ChartData> cpLeadData = generateChannelPartnerChart(leads);
//     // final List<FunnelData> leadStatusFunnelData =
//     //     generateLeadStatusFunnel(leads);

//     final List<ChartModel> lineChartData = [];

//     return SafeArea(
//       child: Stack(
//         children: [
//           // Background Image
//           const Positioned.fill(
//             child: AnimatedGradientBg(),
//           ),
//           // Main Content
//           Scaffold(
//             backgroundColor: Colors
//                 .transparent, // Make Scaffold transparent to show background
//             appBar: AppBar(
//               title: const Text("Dashboard"),
//               backgroundColor:
//                   Colors.transparent, // Make AppBar transparent if needed
//               elevation: 0, // Remove AppBar shadow
//             ),
//             body: RefreshIndicator(
//               onRefresh: _onRefresh,
//               child: ListView(
//                 children: [
//                   // Dropdown for Project Selection
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: DropdownButtonFormField<String>(
//                       value: selectedProject,
//                       hint: Text(
//                         "Select Project",
//                         style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 16), // Customized hint style
//                       ),
//                       items: projects.map((project) {
//                         return DropdownMenuItem<String>(
//                           value: project,
//                           child: Text(
//                             project,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                             ), // Customize item text style
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedProject = value;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none, // Remove default border
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide(
//                               color: Colors.grey.shade300, width: 1.5),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Color.fromARGB(255, 248, 85, 4),
//                             width: 2.0,
//                           ),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 12),
//                       ),
//                       icon: const Icon(Icons.arrow_drop_down,
//                           color: Color.fromARGB(255, 248, 85, 4)),
//                       dropdownColor: Colors.white,
//                     ),
//                   ),

//                   // Cards Section
//                   Padding(
//                     padding: const EdgeInsets.all(3.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               GoRouter.of(context).push(
//                                 "/post-sales-executive-lead-list/Total/${widget.id ?? settingProvider.loggedAdmin!.id!}",
//                               );
//                             },
//                             child: SizedBox(
//                               height: 80,
//                               width: 100, // Set a fixed width
//                               child: MyCard(
//                                 label: "Total Booking",
//                                 value: leadsPostSale.totalItems,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               GoRouter.of(context).push(
//                                 "/post-sales-executive-lead-list/Registration Done/${widget.id ?? settingProvider.loggedAdmin!.id!}",
//                               );
//                             },
//                             child: SizedBox(
//                               height: 80,
//                               width: 100, // Set a fixed width
//                               child: MyCard(
//                                 textColor: Colors.green,
//                                 label: "Registration Done",
//                                 value: leadsPostSale.registrationDone,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               GoRouter.of(context).push(
//                                 "/post-sales-executive-lead-list/EOI Received/${widget.id ?? settingProvider.loggedAdmin!.id!}",
//                               );
//                             },
//                             child: SizedBox(
//                               height: 80,
//                               width: 100, // Set a fixed width
//                               child: MyCard(
//                                 textColor: Colors.orange,
//                                 label: "EOI Received",
//                                 value: leadsPostSale.eoiRecieved,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               GoRouter.of(context).push(
//                                 "/post-sales-executive-lead-list/Cancelled/${widget.id ?? settingProvider.loggedAdmin!.id!}",
//                               );
//                             },
//                             child: SizedBox(
//                               height: 80,
//                               width: 100, // Set a fixed width
//                               child: MyCard(
//                                 textColor: Colors.red.shade700,
//                                 label: "Cancelled",
//                                 value: leadsPostSale.cancelled,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Line Chart with Blurred Background
//                   LineChart(
//                     title: "Booking Over Month",
//                     chartData: leadsOverMonths,
//                   ),
//                   // Doughnut Charts
//                   DoughnutChart(
//                     title: "Booking Report",
//                     chartData: presalesData,
//                     onPressFilter: (filter) {},
//                   ),

//                   FunnelChart(
//                     title: "Booking Funnel",
//                     initialFunnelData: initialFunnelData,
//                     onPressFilter: (filter) {},
//                   ),
//                   const SizedBox(height: 80),
//                 ],
//               ),
//             ),
//           ),
//           // Notification Overlay
//           if (showNotification)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   notificationHeight = 0;
//                   showNotification = false;
//                 });
//               },
//               child: Container(
//                 color: Colors.black.withOpacity(0.05),
//               ),
//             ),
//           // Notification Icon and Panel
//           Positioned(
//             top: 15,
//             right: 15,
//             child: Stack(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       if (showNotification) {
//                         notificationHeight = 0;
//                       } else {
//                         notificationHeight = 200;
//                       }
//                       showNotification = !showNotification;
//                     });
//                   },
//                   icon: const Icon(Icons.notifications),
//                 ),
//                 if (leads.isNotEmpty)
//                   Positioned(
//                     right: 10,
//                     top: 10,
//                     child: Container(
//                       width: 16,
//                       height: 16,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 2, vertical: 1),
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.red,
//                       ),
//                       child: Center(
//                         child: Text(
//                           "${leads.length}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           // Notification Panel
//           if (showNotification)
//             Positioned(
//               top: 60,
//               right: 20,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 660),
//                 width: 200,
//                 height: notificationHeight,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: ListView(
//                   children: [
//                     ...leads.map((lead) {
//                       return ListTile(
//                         leading: const Icon(
//                           Icons.notifications_active,
//                           color: Colors.red,
//                         ),
//                         title: Text(
//                           "New lead from ${lead.firstName} ${lead.lastName}",
//                           style: const TextStyle(
//                             fontSize: 12,
//                           ),
//                           maxLines: 2,
//                         ),
//                         subtitle: Text(
//                           Helper.formatDate(lead.date.toString()),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey.shade800,
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class MyCard extends StatelessWidget {
//   final String label;
//   final int value;
//   final double? width;
//   final Color? textColor;
//   final Color? bgColor;
//   final List<BoxShadow>? boxShadow;

//   const MyCard({
//     super.key,
//     required this.label,
//     required this.value,
//     this.textColor,
//     this.bgColor,
//     this.width,
//     this.boxShadow,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8,
//         horizontal: 5,
//       ),
//       width: width,
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       decoration: BoxDecoration(
//         color: bgColor ??
//             Colors.white.withOpacity(
//                 0.8), // Slight opacity for better background visibility
//         shape: BoxShape.rectangle,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: boxShadow ??
//             [
//               BoxShadow(
//                 color: Colors.grey.withAlpha(50).withOpacity(0.1),
//                 spreadRadius: 1,
//                 blurRadius: 0,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             value.toString(),
//             style: TextStyle(
//               color: textColor ?? Colors.black,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: textColor ?? Colors.black,
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
