import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/components/cp_videoplayer.dart';
import 'package:ev_homes/core/models/meetingSummary.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/customer_pages/customer_forms/meeting_summary_page.dart';
import 'package:ev_homes/wrappers/customer_home_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// import '../../customer wrappers/home_wrapper.dart';

class MyMeetings extends StatefulWidget {
  MyMeetings({super.key});

  @override
  State<MyMeetings> createState() => _MyMeetingsState();
}

class _MyMeetingsState extends State<MyMeetings> {
  bool isLoading = false;
  final List<Map<String, String>> completedMeetings = [];

  Future<void> _onRefresh() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    // print("pass 1");
    try {
      setState(() {
        isLoading = true;
      });
      // print("pass 2");
      // Execute all three futures concurrently
      await Future.wait([
        settingProvider
            .getClientMeetingById(settingProvider.loggedCustomer?.id ?? ""),
        // settingProvider.getPayment(),
      ]);
      // print("pass 3");
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final meetingSummary = settingProvider.meeting;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF042630)),
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
            color: Color(0xFF042630),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            const Positioned.fill(
              child: CpVideoplayer(),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: meetingSummary.length,
                      itemBuilder: (context, index) {
                        final meeting = meetingSummary[index];
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

  Widget _buildMeetingCard(BuildContext context, MeetingSummary meeting) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MeetingSummaryPage(
              title: meeting.purpose ?? "",
              description: meeting.summary ?? "",
              date: meeting.date.toString(),
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
                        meeting.purpose ?? "",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF2e2252),
                        ),
                      ),
                    ),
                    _buildDateChip(meeting.date.toString()),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  meeting.summary ?? "",
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
                      DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(meeting.date.toString())),
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
