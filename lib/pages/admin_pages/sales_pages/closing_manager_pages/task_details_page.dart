import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TaskDetailsPage extends StatefulWidget {
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Client Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextCard(
                              heading: "Client Name: ",
                              value: "Somiya Agarwal",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                                heading: "Phone: ", value: "+91 90876542109"),
                            SizedBox(height: 8),
                            MyTextCard(
                                heading: "Alternate Number: ",
                                value: "+91 987654221"),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Email: ",
                              value: "Roh@gmail.com",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Requirement: ",
                              value: "2BHK",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                                heading: "Call Status: ",
                                value: "Follow Up Call"),
                            SizedBox(height: 8),
                            MyTextCard(
                                heading: "Lead Status: ", value: "approved"),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Interested: ",
                              value: "Hot",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Team Leader: ",
                              value: "Harshal Kokate",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Data Analyzer: ",
                              value: "Narayan Jha",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Task Assing To: ",
                              value: "Manisha",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                                heading: "Start Date: ", value: "02 Dec 2024"),
                            SizedBox(height: 8),
                            MyTextCard(
                                heading: "Valid Till: ", value: "31 Jan 2025 "),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Project: ",
                              value: "9 Square",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Requirement: ",
                              value: "2BHK3BHK",
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Channel Partner Details',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextCard(
                              heading: "Name: ",
                              value: "Rohit Rathate",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Firm Name: ",
                              value: "Rohit2",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Rera Registration: ",
                              value: "No",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                              heading: "Rera Id: ",
                              value: "A12",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 400, // Constrained height for the stepper
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView(
                        children: const [
                          CustomTimelineTile(
                            title: "Approved",
                            date: "10/10/2024",
                            description: "welcome to ev home",
                            color: Colors.orange,
                            isFirst: true,
                          ),
                          CustomTimelineTile(
                            title: "Contacted",
                            date: "10/10/2024",
                            description: "welcome to ev home",
                            color: Colors.orange,
                          ),
                          CustomTimelineTile(
                            title: "Follow Up",
                            date: "10/10/2024",
                            description: "welcome to ev home",
                            color: Colors.orange,
                          ),
                          CustomTimelineTile(
                            title: "Site Visit",
                            date: "10/10/2024",
                            description: "welcome to ev home",
                            color: Colors.orange,
                          ),
                          CustomTimelineTile(
                            title: "Revisit",
                            date: "10/10/2024",
                            description: "welcome to ev home",
                            color: Colors.orange,
                          ),
                          CustomTimelineTile(
                            title: "Booking",
                            date: "10/10/2024",
                            description: "welcome to ev home",
                            color: Colors.orange,
                          ),
                          CustomTimelineTile(
                            title: "Registration",
                            date: "10/10/2024",
                            description: "welcome to ev home",
                            color: Color.fromARGB(255, 255, 223, 174),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyTextCard extends StatelessWidget {
  final String heading;
  final String value;
  final Color? headingColor;
  final Color? valueColor;
  const MyTextCard({
    super.key,
    required this.heading,
    required this.value,
    this.headingColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: headingColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 15, color: valueColor),
        ),
      ],
    );
  }
}

class CustomTimelineTile extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final Color color;
  final bool isFirst;
  final bool isLast;

  const CustomTimelineTile({
    Key? key,
    required this.title,
    required this.date,
    required this.description,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(color: color),
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: color,
        iconStyle: IconStyle(iconData: Icons.done, color: Colors.white),
      ),
      endChild: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
