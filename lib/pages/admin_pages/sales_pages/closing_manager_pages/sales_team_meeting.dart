import 'package:flutter/material.dart';

class SalesTeamMeeting extends StatefulWidget {
  @override
  State<SalesTeamMeeting> createState() => _SalesTeamMeetingState();
}

class _SalesTeamMeetingState extends State<SalesTeamMeeting> {
  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Meeting Notification'),
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
                              heading: "Subject: ",
                              value: "Sales Plan Overview",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                                heading: "Detais: ",
                                value:
                                    "Feedback and Suggestions: Open discussion for ideas and improvements."),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                              heading: "Subject: ",
                              value: "Sales Action Plan",
                            ),
                            SizedBox(height: 8),
                            MyTextCard(
                                heading: "Detais: ",
                                value:
                                    "Team Collaboration: Suggestions for team strategies and support needs."),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: headingColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 15, color: valueColor),
          maxLines: null, // Allows unlimited lines
          softWrap: true, // Ensures text wraps to the next line
        ),
      ],
    );
  }
}
