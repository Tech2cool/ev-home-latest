import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/animated_pie_chart.dart';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/components/my_transculent_box.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/our_project.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/inventory_page1.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_marina_bay.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/costsheet_generator_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/demand_letter_9_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule%20_nine_square.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/payment_schedule_marina_bay.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/admin_carry_forward_page.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/closing_manager_pages/task_list_page.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClosingManagerDashboard extends StatefulWidget {
  final String? id;

  const ClosingManagerDashboard({super.key, this.id});

  @override
  State<ClosingManagerDashboard> createState() =>
      _ClosingManagerDashboardState();
}

class _ClosingManagerDashboardState extends State<ClosingManagerDashboard> {
  bool showNotification = false;
  double notificationHeight = 0;
  String? selectedOption;

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
      await settingProvider.getTeamLeaderLeads(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );

      await settingProvider.getMyTarget(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
      await settingProvider.getClosingManagerGraph(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
      await settingProvider.getCarryForwardOpt(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
      await settingProvider.getTask(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
      await settingProvider.ourProject;
      await settingProvider.getOurProject();
    } catch (e) {
      // Helper
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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

  double safeDivision(double numerator, double denominator) {
    if (denominator == 0) {
      return 0;
    }
    return (numerator / denominator).floorToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final teamLeaderLeads = settingProvider.leadsTeamLeader;
    final target = settingProvider.myTarget;
    final graphInfo = settingProvider.closingManagerGraph;

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
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      MediaQuery.of(context).size.width - 50,
                      kToolbarHeight + 10,
                      0,
                      0,
                    ),
                    items: const [
                      PopupMenuItem(
                        value: 'monthly',
                        child: Text('Monthly'),
                      ),
                      PopupMenuItem(
                        value: 'quarterly',
                        child: Text('Quarterly'),
                      ),
                      PopupMenuItem(
                        value: 'semi_annually',
                        child: Text('Semi-Annually'),
                      ),
                      PopupMenuItem(
                        value: 'annually',
                        child: Text('Annually'),
                      ),
                    ],
                  ).then((selectedFilter) {
                    if (selectedFilter != null) {
                      print('Selected filter: $selectedFilter');
                    }
                  });
                },
              ),
            ],
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
                              "/closing-manager-lead-list/total/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
                          },
                          child: MyCard(
                            label: "Leads",
                            value: teamLeaderLeads.totalItems,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push(
                              "/closing-manager-lead-list/visit/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
                          },
                          child: MyCard(
                            textColor: Colors.green,
                            label: "Visit 1",
                            value: teamLeaderLeads.visitCount,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         ClosingManagerVisit2ListPage(
                            //       id: widget.id,
                            //       status: "Walk-in",
                            //     ),
                            //   ),
                            // );
                            GoRouter.of(context).push(
                              "/closing-manager-lead-list/visit2/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
                          },
                          child: MyCard(
                            textColor: Colors.red,
                            label: "Visit 2",
                            value: teamLeaderLeads.visit2Count,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            //TODO: closing manager booking
                            GoRouter.of(context).push(
                              "/closing-manager-lead-list/booking/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
                          },
                          child: MyCard(
                            textColor: Colors.yellow.shade700,
                            label: "Booking",
                            value: teamLeaderLeads.bookingCount,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push(
                              "/closing-manager-lead-list/pending/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
                          },
                          child: MyCard(
                            textColor: Colors.red,
                            label: "Pending",
                            value: teamLeaderLeads.pendingCount,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(116, 218, 207, 120),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Target",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.filter_alt),
                            onPressed: () {
                              showMenu(
                                context: context,
                                position:
                                    const RelativeRect.fromLTRB(100, 80, 20, 0),
                                items: const [
                                  PopupMenuItem(
                                    value: 'January',
                                    child: Text('January'),
                                  ),
                                  PopupMenuItem(
                                    value: 'February',
                                    child: Text('February'),
                                  ),
                                  PopupMenuItem(
                                    value: 'March',
                                    child: Text('March'),
                                  ),
                                  PopupMenuItem(
                                    value: 'April',
                                    child: Text('April'),
                                  ),
                                  PopupMenuItem(
                                    value: 'May',
                                    child: Text('May'),
                                  ),
                                  PopupMenuItem(
                                    value: 'June',
                                    child: Text('June'),
                                  ),
                                  PopupMenuItem(
                                    value: 'July',
                                    child: Text('July'),
                                  ),
                                  PopupMenuItem(
                                    value: 'August',
                                    child: Text('August'),
                                  ),
                                  PopupMenuItem(
                                    value: 'September',
                                    child: Text('September'),
                                  ),
                                  PopupMenuItem(
                                    value: 'October',
                                    child: Text('October'),
                                  ),
                                  PopupMenuItem(
                                    value: 'November',
                                    child: Text('November'),
                                  ),
                                  PopupMenuItem(
                                    value: 'December',
                                    child: Text('December'),
                                  ),
                                ],
                              ).then((selectedmonth) {
                                if (selectedmonth != null) {
                                  Helper.showCustomSnackBar(
                                    "No Target info available for $selectedmonth",
                                    Colors.green,
                                  );
                                  // print('Selected filter: $selectedmonth');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: TargetCircle(
                                  number: target?.target.toString() ?? "0",
                                  label: "Target",
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {},
                                child: TargetCircle(
                                  number: target?.achieved.toString() ?? "0",
                                  label: "Achieved",
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  showDialog<int>(
                                    context: context,
                                    builder: (context) =>
                                        AdminCarryForwardDialog(
                                      id: widget.id,
                                    ),
                                  );

                                  // if (selectedValue != null) {
                                  // print(
                                  //     "Selected Carry Forward Option: $selectedValue");
                                  // }
                                },
                                child: TargetCircle(
                                  number:
                                      target?.carryForward.toString() ?? "0",
                                  label: "Carry Forward",
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
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
                                                .where((ele) =>
                                                    ele.completed == false)
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
                              onTap: () =>
                                  _showProjectDialogForPaymentSchedule(),
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
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Card(
                  elevation: 4,
                  shadowColor: Colors.transparent,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Lead to Visit 1",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        AnimatedPieChart(
                          visited: graphInfo.visitCount.toInt(),
                          notVisited: graphInfo.leadCount.toInt(),
                          percentage: safeDivision((graphInfo.visitCount * 100),
                              graphInfo.leadCount),
                          title: "Visits",
                          subtitle: "Visit 1",
                          notSubtitle: "Lead",
                          visitedColor: Colors.blue,
                          notVisitedColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  shadowColor: Colors.transparent,

                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white
                      .withOpacity(0.3), // Semi-transparent white background
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Visit 1 to Booking",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        AnimatedPieChart(
                          visited: graphInfo.bookingCount.toInt(),
                          notVisited: graphInfo.visitCount.toInt(),
                          percentage: safeDivision(
                            (graphInfo.bookingCount * 100),
                            graphInfo.visitCount,
                          ),
                          title: "Visits",
                          subtitle: "Booking",
                          notSubtitle: "Visit 1",
                          visitedColor: Colors.green,
                          notVisitedColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  shadowColor: Colors.transparent,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Visit 2 to Booking",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        AnimatedPieChart(
                          visited: graphInfo.bookingCount.toInt(),
                          notVisited: graphInfo.visit2Count.toInt(),
                          percentage: safeDivision(
                              (graphInfo.bookingCount * 100),
                              graphInfo.visit2Count),
                          title: "Bookings",
                          subtitle: "Booking",
                          notSubtitle: "Visit 2",
                          visitedColor: Colors.purple,
                          notVisitedColor: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  shadowColor: Colors.transparent,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Lead to Booking",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        AnimatedPieChart(
                          visited: graphInfo.bookingCount.toInt(),
                          notVisited: graphInfo.leadCount.toInt(),
                          percentage: safeDivision(
                              (graphInfo.bookingCount * 100),
                              graphInfo.leadCount),
                          title: "Bookings",
                          subtitle: "Booking",
                          notSubtitle: "Lead",
                          visitedColor: Colors.teal,
                          notVisitedColor: Colors.pink,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading) const LoadingSquare(),
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
          FittedBox(
            child: Text(
              value.toString(),
              style: TextStyle(
                color: textColor ?? Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          FittedBox(
            child: Text(
              label,
              style: TextStyle(
                color: textColor ?? Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TargetCircle extends StatelessWidget {
  final String number; // Replace the icon with number
  final String label;
  final Color backgroundColor;

  const TargetCircle({
    required this.number,
    required this.label,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(100, 226, 225, 216),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number, // Display the number in the circle
                style: const TextStyle(
                  fontSize: 24, // Font size for the number
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

void _showDialogWithTable(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Follow Up Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Client Name")),
                        DataColumn(label: Text("Phone")),
                        DataColumn(label: Text("Visit Date")),
                        DataColumn(label: Text("Follow-Up Status")),
                        DataColumn(label: Text("Notification")),
                        DataColumn(label: Text("Revisit Date")),
                        DataColumn(label: Text("Booking Date")),
                      ],
                      rows: [
                        _buildDataRow(
                          context,
                          "John Doe",
                          "1234567890",
                          "23/10/2024",
                          "Booking",
                          "Reminder Sent",
                          "25/10/2024",
                          "28/10/2024",
                        ),
                        _buildDataRow(
                          context,
                          "Jane Smith",
                          "0987654321",
                          "20/10/2024",
                          "Pending",
                          "Not Sent",
                          "22/10/2024",
                          "30/10/2024",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

DataRow _buildDataRow(
  BuildContext context,
  String name,
  String phone,
  String visitDate,
  String status,
  String notification,
  String revisitDate,
  String bookingDate,
) {
  return DataRow(
    cells: [
      _buildNavigableDataCell(context, name),
      _buildNavigableDataCell(context, phone),
      _buildNavigableDataCell(context, visitDate),
      _buildNavigableDataCell(context, status),
      _buildNavigableDataCell(context, notification),
      _buildNavigableDataCell(context, revisitDate),
      _buildNavigableDataCell(context, bookingDate),
    ],
  );
}

DataCell _buildNavigableDataCell(BuildContext context, String text) {
  return DataCell(
    GestureDetector(
      onTap: () {
        //TODO: closing manager Client details

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ClientDetails(),
        //   ),
        // );
      },
      child: Text(text),
    ),
  );
}

void _showAssignTaskDialog(BuildContext context) {
  String? selectedAssignee; // Variable for dropdown selection
  final subjectController = TextEditingController();
  final taskNameController = TextEditingController();
  final taskDetailsController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Assign Task",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Subject"),
                const SizedBox(height: 5),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Task Name"),
                const SizedBox(height: 5),
                TextField(
                  controller: taskNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Task Details"),
                const SizedBox(height: 5),
                TextField(
                  controller: taskDetailsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Assign To"),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selectedAssignee,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ["John Doe", "Jane Smith", "Alex Brown", "Maria Lee"]
                      .map((name) => DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedAssignee = value;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
