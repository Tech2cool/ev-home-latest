import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_path/fun_extra.dart';

class SalesmangerDashbord extends StatefulWidget {
  const SalesmangerDashbord({super.key});

  @override
  State<SalesmangerDashbord> createState() => _SalesmangerDashbordState();
}

double leadValue = 200;
double visitValue = 150;
double booking = 50;
double onthervisit = 100;

double visitepercentage = (visitValue * 100) / leadValue;
double visitbooking = (booking * 100) / visitValue;
double onthervisite = (booking * 100) / onthervisit;
double leadbooking = (booking * 100) / leadValue;

class _SalesmangerDashbordState extends State<SalesmangerDashbord> {
  bool showNotification = false;
  double notificationHeight = 0;
  String? selectedOption;

  final Map<String, List<PieChartSectionData>> chartData = {
    "lead_to_visit": [
      PieChartSectionData(
        value: visitepercentage,
        color: Colors.blue,
        title: 'visit1 ${visitepercentage.toStringAsFixed(1)}%',
      ),
      PieChartSectionData(
        value: 100 - visitepercentage, // Remaining value
        color: Colors.purple,
        title: 'Leads ${(100 - visitepercentage).toStringAsFixed(1)}%',
      ),
    ],
    "visit1_to_booking": [
      PieChartSectionData(
        value: visitbooking,
        color: Colors.red,
        title: 'Booking ${visitbooking.toStringAsFixed(1)}%',
      ),
      PieChartSectionData(
        value: 100 - visitbooking, // Remaining value
        color: Colors.blue,
        title: 'Visit1 ${(100 - visitbooking).toStringAsFixed(1)}%',
      ),
    ],
    "visit2_to_booking": [
      PieChartSectionData(
        value: onthervisite,
        color: Colors.green,
        title: 'Booking ${onthervisite.toStringAsFixed(1)}%',
      ),
      PieChartSectionData(
        value: 100 - onthervisite, // Remaining value
        color: Colors.pink,
        title: 'Visit2 ${(100 - onthervisite).toStringAsFixed(1)}%',
      ),
    ],
    "lead_to_booking": [
      PieChartSectionData(
        value: onthervisite,
        color: Colors.brown,
        title: 'Booking ${onthervisite.toStringAsFixed(1)}%',
      ),
      PieChartSectionData(
        value: 100 - onthervisite, // Remaining value
        color: Colors.blue,
        title: 'Leads ${(100 - onthervisite).toStringAsFixed(1)}%',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Gradient Background
          Positioned.fill(
            child: AnimatedGradientBg(),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("Dashboard"),
              backgroundColor: Colors.transparent, // Transparent AppBar
              elevation: 0, // Remove AppBar shadow
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_alt),
                        onPressed: () {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(100, 80, 20, 0),
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
                          ).then((selectedmonth) {
                            if (selectedmonth != null) {
                              print('Selected filter: $selectedmonth');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //TODO: leads route sale manager

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => SalesmangerLead()),
                              // );
                            },
                            child: MyCard(
                              label: "Leads",
                              value: 10,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //TODO: visit route sale manager
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           SalesmanagerVisitone()),
                              // );
                            },
                            child: MyCard(
                              textColor: Colors.green,
                              label: "Visit 1",
                              value: 5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //TODO: revisit route sale manager

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           SalesmanagerVisitetwo()),
                              // );
                            },
                            child: MyCard(
                              textColor: Colors.red,
                              label: "Visit 2",
                              value: 3,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //TODO: booking route sale manager

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => SalemangerBooking()),
                              // );
                            },
                            child: MyCard(
                              textColor: Colors.yellow.shade700,
                              label: "Booking",
                              value: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(154, 255, 254, 245),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text("Select an option"),
                              value: selectedOption,
                              items: const [
                                DropdownMenuItem(
                                  value: "lead_to_visit",
                                  child: Text("Lead to Visit"),
                                ),
                                DropdownMenuItem(
                                  value: "visit1_to_booking",
                                  child: Text("Visit 1 to Booking"),
                                ),
                                DropdownMenuItem(
                                  value: "visit2_to_booking",
                                  child: Text("Visit 2 to Booking"),
                                ),
                                DropdownMenuItem(
                                  value: "lead_to_booking",
                                  child: Text("Lead to Booking"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value;
                                });
                              },
                              icon: const Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        ),
                        if (selectedOption != null)
                          SizedBox(
                            height: 250,
                            width: 400,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  PieChartData(
                                    sections: chartData[selectedOption]!,
                                    centerSpaceRadius: 70,
                                    sectionsSpace: 2,
                                  ),
                                ),
                                const Text(
                                  "Conversion",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(116, 218, 207, 120),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Target",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.filter_alt),
                              onPressed: () {
                                showMenu(
                                  context: context,
                                  position:
                                      RelativeRect.fromLTRB(100, 80, 20, 0),
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
                                      child: Text('April'),
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
                                child: const Target(
                                  number:
                                      "20", // Replace the icon with a number
                                  label: "Target",
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {},
                                child: const Target(
                                  number:
                                      "15", // Replace the icon with a number
                                  label: "Achieved",
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {},
                                child: const Target(
                                  number: "5", // Replace the icon with a number
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
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    //TODO: Client list
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           ManagerClientlist()),
                                    // );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 241, 118, 11),
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
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(150, 40),
                          ),
                          onPressed: () {
                            _showTaskDialog(context);
                          },
                          child: const Text(
                            "Task",
                            style: TextStyle(color: Colors.white), // Text color
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
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

class Target extends StatelessWidget {
  final String number; // Replace the icon with number
  final String label;
  final Color backgroundColor;

  const Target({
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
        //TODO: Client details route sale manager

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ManagerClientDetails(),
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
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text("Complete Report"),
                      ),
                      ListTile(
                        leading: Icon(Icons.task_alt, color: Colors.blue),
                        title: Text("Schedule Meeting"),
                      ),
                      ListTile(
                        leading: Icon(Icons.note, color: Colors.orange),
                        title: Text("Review Notes"),
                      ),
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.red),
                        title: Text("Send Emails"),
                      ),
                      ListTile(
                        leading: Icon(Icons.add_alert, color: Colors.purple),
                        title: Text("Set Reminder"),
                      ),
                      ListTile(
                        leading: Icon(Icons.update, color: Colors.teal),
                        title: Text("Update Database"),
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
