import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/pages/customer_pages/customer_forms/meeting_summary_page.dart';
import 'package:ev_homes/wrappers/customer_home_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import '../../customer wrappers/home_wrapper.dart';

class MyMeetings extends StatelessWidget {
  final List<Map<String, String>> completedMeetings = [
    {
      'title': 'Booking',
      'description': 'Discuss about flat booking',
      'time': '10:00 AM - 12:00 PM',
      'date': '2023-10-15',
    },
    {
      'title': 'Registration',
      'description': 'Registration of flat.',
      'time': '9:00 AM - 12:00 PM',
      'date': '2023-10-20',
    },
  ];

  MyMeetings({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerHomeWrapper()),
        );
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomerHomeWrapper()),
              );
            },
          ),
          title: const Text(
            'My Meetings',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            const Positioned.fill(
              child: AnimatedGradientBg(),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: completedMeetings.length,
                      itemBuilder: (context, index) {
                        final meeting = completedMeetings[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildMeetingCard(context, meeting),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingCard(BuildContext context, Map<String, String> meeting) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MeetingSummaryPage(
              title: meeting['title']!,
              description: meeting['description']!,
              date: meeting['time']!,
            ),
          ),
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.blue.shade50,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        meeting['title']!,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF2e2252),
                        ),
                      ),
                    ),
                    _buildDateChip(meeting['date']!),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  meeting['description']!,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 18,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      meeting['time']!,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip(String dateString) {
    final date = DateTime.parse(dateString);
    final formattedDate = DateFormat('MMM d').format(date);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        formattedDate,
        style: const TextStyle(
          fontFamily: 'Roboto',
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
