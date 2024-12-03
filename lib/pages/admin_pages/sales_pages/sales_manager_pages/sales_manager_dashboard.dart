import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/animated_pie_chart.dart';
import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/admin_carry_forward_page.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/closing_manager_pages/view_task_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SalesManagerDashboard extends StatefulWidget {
  final String? id;

  const SalesManagerDashboard({super.key, this.id});

  @override
  State<SalesManagerDashboard> createState() => _SalesManagerDashboardState();
}

double leadValue = 200;
double visitValue = 150;
double booking = 50;
double onthervisit = 100;

double visitepercentage = (visitValue * 100) / leadValue;
double visitbooking = (booking * 100) / visitValue;
double onthervisite = (booking * 100) / onthervisit;
double leadbooking = (booking * 100) / leadValue;

class _SalesManagerDashboardState extends State<SalesManagerDashboard> {
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
        widget.id ?? settingProvider.loggedAdmin!.reportingTo!.id!,
      );

      await settingProvider.getMyTarget(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
      await settingProvider.getClosingManagerGraph(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
      // await settingProvider.getLeadsTeamLeaderGraph(
      //   widget.id ?? settingProvider.loggedAdmin!.id!,
      // );
      // await settingProvider.getPreSaleExecutiveGraph();
      // await settingProvider.getLeadsFunnelGraph();
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
                            GoRouter.of(context).push(
                              "/closing-manager-lead-list/revisit/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                            );
                          },
                          child: MyCard(
                            textColor: Colors.red,
                            label: "Visit 2",
                            value: teamLeaderLeads.revisitCount,
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
                                  print('Selected filter: $selectedmonth');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
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
                                final selectedValue = showDialog<int>(
                                  context: context,
                                  builder: (context) =>
                                      AdminCarryForwardDialog(id: "123"),
                                );

                                if (selectedValue != null) {
                                  print(
                                      "Selected Carry Forward Option: $selectedValue");
                                }
                              },
                              child: TargetCircle(
                                number: target?.carryForward.toString() ?? "0",
                                label: "Carry Forward",
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  //TODO: closing manager client List
                                  GoRouter.of(context).push(
                                    "/closing-manager-follow-up-list/followup/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 241, 118, 11),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: const Text(
                                  'Follow Up Satus',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  //TODO: closing manager client List
                                  _showTaskDialog(context);
                                  // GoRouter.of(context).push(
                                  //   "/closing-manager-follow-up-list/followup/${widget.id ?? settingProvider.loggedAdmin!.id!}",
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: const Text(
                                  'My Task',
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Card(
                  elevation: 4,
                  shadowColor: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white.withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Lead to Visit 1",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        AnimatedPieChart(
                          visited: graphInfo.visitCount.toInt(),
                          notVisited: graphInfo.leadCount.toInt(),
                          percentage: safeDivision((graphInfo.visitCount * 100),
                              graphInfo.leadCount),
                          title: "Visits",
                          subtitle: "Visit",
                          notSubtitle: "Not Visit",
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

                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white
                      .withOpacity(0.3), // Semi-transparent white background
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Visit 1 to Booking",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        AnimatedPieChart(
                          visited: 60,
                          notVisited: 40,
                          percentage: safeDivision(
                              (graphInfo.bookingCount * 100),
                              graphInfo.visitCount),
                          title: "Visits",
                          subtitle: "Visit",
                          notSubtitle: "Not Visit",
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
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white.withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Visit 2 to Booking",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        AnimatedPieChart(
                          visited: graphInfo.bookingCount.toInt(),
                          notVisited: graphInfo.visit2Count.toInt(),
                          percentage: safeDivision(
                              (graphInfo.bookingCount * 100),
                              graphInfo.visit2Count),
                          title: "Bookings",
                          subtitle: "Visit",
                          notSubtitle: "Not Visit",
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
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white.withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Lead to Booking",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        AnimatedPieChart(
                          visited: graphInfo.bookingCount.toInt(),
                          notVisited: graphInfo.leadCount.toInt(),
                          percentage: safeDivision(
                              (graphInfo.bookingCount * 100),
                              graphInfo.leadCount),
                          title: "Bookings",
                          subtitle: "Visit",
                          notSubtitle: "Not Visit",
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

void _showTaskDialog(BuildContext context) {
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
                            const Icon(Icons.check_circle, color: Colors.green),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  "11",
                                  style: TextStyle(
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
                              builder: (context) => ViewTaskPage(),
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
                                child: const Text(
                                  "10",
                                  style: TextStyle(
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
                              builder: (context) => ViewTaskPage(),
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
                                child: const Text(
                                  "4",
                                  style: TextStyle(
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
                              builder: (context) => ViewTaskPage(),
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
